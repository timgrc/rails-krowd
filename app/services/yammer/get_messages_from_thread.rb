class Yammer::GetMessagesFromThread
  def initialize(user, thread_id)
    @yam       = Yammer::Client.new(access_token: user.access_token)
    @thread_id = thread_id
  end

  def call
    thread = @yam.messages_in_thread(@thread_id)
    thread.body[:messages].map do |post|
      {
        id:            post[:id],
        sender_id:     post[:sender_id],
        replied_to_id: post[:replied_to_id],
        plain:         post[:body][:plain],
        rich:          post[:body][:rich],
        liked_by:      post[:liked_by]
      }
    end
  end
end

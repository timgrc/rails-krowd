class GetCommentsFromPosts
  def initialize(user, thread_id)
    @yam       = Yammer::Client.new(access_token: user.access_token)
    @thread_id = thread_id
  end

  def call
    yam_posts = @yam.messages_in_thread(@thread_id)
    yam_posts.body[:messages].map do |post|
      # raise
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

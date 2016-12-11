class Yammer::GetMessagesFromGroup
  def initialize(user, group_id)
    @yam      = Yammer::Client.new(access_token: user.access_token)
    @group_id = group_id
  end

  def call
    message = @yam.messages_in_group(@group_id)
    message.body[:messages].map do |post|
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

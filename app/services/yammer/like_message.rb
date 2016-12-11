class Yammer::LikeMessage
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    @yam.like_message @message_id
  end
end

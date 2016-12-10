class Yammer::LikeMessage
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    p @yam.post('/api/v1/messages/liked_by/current.json', message_id: @message_id)
  end
end

class Yammer::GetLikesFromMessage
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    likes = @yam.get("/api/v1/users/liked_message/#{@message_id}.json").body[:users]

    likes.map do |like|
      {
        id:        like[:id],
        full_name: like[:full_name]
      }
    end
  end
end

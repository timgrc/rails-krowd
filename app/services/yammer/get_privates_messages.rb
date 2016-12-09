class Yammer::GetPrivatesMessages
  def initialize(bot_user)
    @yam = Yammer::Client.new(access_token: bot_user.access_token)
  end

  def call
    yam_private_messages = @yam.private_messages.body[:messages]
    yam_private_messages.map do |private_message|
      {
        sender_id: private_message[:sender_id],
        plain:     private_message[:body][:plain]
      }
    end
  end
end

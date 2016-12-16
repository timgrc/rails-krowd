class Yammer::GetLastPrivateMessagesFromBotUser
  def initialize(bot)
    @bot = bot
  end

  def call
    private_messages = Yammer::GetPrivateMessages.new(@bot.user).call

    new_private_messages = private_messages.take_while do |private_message|
      private_message[:sender_id].to_i != @bot.user.rse_id.to_i
    end

    unless new_private_messages.nil?
      new_private_messages.first
    else
      return false
    end
  end
end

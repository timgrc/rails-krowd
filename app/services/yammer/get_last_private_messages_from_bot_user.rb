class Yammer::GetLastPrivateMessagesFromBotUser
  def initialize(bot)
    @bot = bot
  end

  def call
    private_messages = Yammer::GetPrivateMessages.new(@bot.user).call

    new_private_messages = private_messages.take_while do |private_message|
      private_message[:id] != @bot.latest_rse_replied_id
    end

    unless new_private_messages.nil?
      new_private_messages.select do |private_message|
        private_message[:sender_id] != @bot.user.rse_id
      end
    else
      return false
    end
  end
end

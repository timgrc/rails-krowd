class Yammer::GetLastPrivateMessagesFromBotUser
  def initialize(bot_user)
    @bot_user = bot_user
  end

  def call
    private_messages = GetPrivateMessages.new(@bot_user).call

    new_private_messages = private_messages.take_while do |private_message|
      private_message[:id] != @bot_user.rse_last_answered_message_id
    end

    new_private_messages.select do |private_message|
      private_message[:sender_id] != @bot_user.rse_user_id
    end
  end
end

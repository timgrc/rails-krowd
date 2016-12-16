require 'yammer'

class UseBot
  def initialize(bot)
    @bot = bot
  end

  def call
    user_question = Yammer::GetLastPrivateMessagesFromBotUser.new(@bot).call
    yam = Yammer::Client.new(access_token: @bot.user.access_token)

    bot_answer = CalculateBotAnswer.new(user_question[:plain]).call

    wagon_pic = File.open(Rails.root.join("app/assets/images/le_wagon.jpeg"))
    yam.create_message(bot_answer, replied_to_id: user_question[:id] , direct_to_user_ids: user_question[:sender_id], attachment1: wagon_pic)
  end
end

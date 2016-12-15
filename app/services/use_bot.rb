require 'yammer'

class UseBot
  def initialize(bot)
    @bot = bot
  end

  def call
    user_questions = Yammer::GetLastPrivateMessagesFromBotUser.new(@bot).call
    yam = Yammer::Client.new(access_token: @bot.user.access_token)

    if user_questions
      user_question = user_questions.first
      user_questions.each do |user_question|
        bot_answer = CalculateBotAnswer.new(user_question[:plain]).call

        yam.create_message(bot_answer, replied_to_id: user_question[:id] , direct_to_user_ids: user_question[:sender_id])

        @bot.latest_rse_replied_id = user_question[:id]
        @bot.save
      end
    end
  end
end

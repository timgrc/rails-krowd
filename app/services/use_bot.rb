require 'yammer'

class UseBot
  def initialize(bot)
    @bot = bot
  end

  def call
    user_questions = Yammer::GetLastPrivateMessagesFromBotUser.new(@bot).call
    if user_questions
      user_question = user_questions.first
      # user_questions.each do |user_question|
        bot_answer = CalculateBotAnswer.new(user_question[:plain]).call

        # opts = { direct_to_user_ids: [user_question[:sender_id]] }
        opts = { group_id: 10022956 }
        Yammer::PostMessage.new(@bot.user, 'TestBot', opts)
        # @bot.latest_rse_replied_id = user_question[:id]
        # @bot.save
      # end
    end
  end
end

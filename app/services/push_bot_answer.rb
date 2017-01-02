require 'yammer'

class PushBotAnswer
  def initialize(bot, question)
    @bot      = bot
    @question = question
  end

  def call
    yam = Yammer::Client.new(access_token: @bot.user.access_token)
    if @question[:sender_id].to_i != @bot.user.rse_id
      bot_answer = CalculateBotAnswer.new(@question[:plain]).call
      yam.create_message("Hello #{@question[:first_name]},\n" + bot_answer, replied_to_id: @question[:id], direct_to_user_ids: @question[:sender_id])
    end
  end
end

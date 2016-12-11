class CalculateBotAnswer
  def initialize(user_question)
    @user_question = user_question
  end

  def call
    bot_answers = [
      {
        regex:  /wagon/i,
        answer: 'The Wagon is the best !'
      },
      {
        regex:  /active members/i,
        answer: '30%'
      }
    ]

    bot_correct_answers = bot_answers.map do |bot_answer|
      bot_answer[:answer] if @user_question =~ bot_answer[:regex]
    end

    bot_correct_answers.join('\n')
  end
end

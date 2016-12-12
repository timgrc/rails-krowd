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
      },
      {
        regex:  /total members/i,
        answer: '100 collaborators invited'
      },
      {
        regex:  /most active/i,
        answer: 'Jean-Louis David is the activist of the week'
      },
      {
        regex:  /most notifications/i,
        answer: 'Jacques Dessange is the networker of the week'
      },
      {
        regex:  /most ideas/i,
        answer: 'Frank Provost is the inventor of the week'
      },
      {
        regex:  /most knowledges/i,
        answer: 'Sergio Bossi is the mastermind of the week'
      },
      {
        regex:  /most likes comments/i,
        answer: 'Jean-Claud Biguine is the influencer of the week'
      }
    ]

    bot_correct_answers = bot_answers.map do |bot_answer|
      bot_answer[:answer] if @user_question =~ bot_answer[:regex]
    end

    bot_correct_answers = bot_correct_answers.select { |bot_answer| !bot_answer.nil? }

    if !bot_correct_answers.empty?
      bot_correct_answers.join('\n')
    else
      "For this question \"#{@user_question}\" : Sorry, I did not understand the question ^^.\nTry Again ..."
    end
  end
end

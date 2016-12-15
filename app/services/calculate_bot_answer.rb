class CalculateBotAnswer
  def initialize(user_question)
    @user_question = user_question
  end

  def call
    bot_answers = [
      {
        regex:  /wagon/i,
        answer: 'The Wagon is the best!'
      },
      {
        regex:  /active members/i,
        answer: "There is #{active_members} of active members in this Challenge."
      },
      {
        regex:  /most active/i,
        answer: "#{activist} is the activist of the week"
      }
    ]

    bot_correct_answers = bot_answers.map do |bot_answer|
      bot_answer[:answer] if @user_question =~ bot_answer[:regex]
    end

    bot_correct_answers = bot_correct_answers.select { |bot_answer| !bot_answer.nil? }

    if !bot_correct_answers.empty?
      bot_correct_answers.join('\n')
    else
      "Sorry, I did not understand the question ^^.\nTry Again ..."
    end
  end

  def activist
    "#{KpiDash.new(@group, 'activist').call[:user].first_name} #{KpiDash.new(@group, 'activist').call[:user].last_name}"
  end

  def active_members
    "#{KpiDash.new(@group, 'members_ratio').call} %"
  end
end

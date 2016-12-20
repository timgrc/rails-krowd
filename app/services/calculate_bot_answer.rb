 class CalculateBotAnswer
  def initialize(user_question)
    @user_question = user_question
    @group = Group.find_by_full_name('Innovation Challenge - The Company')
  end

  def call
    bot_answers = [
      {
        regex:  /wagon/i,
        answer: 'The Wagon is the best!'
      },
      {
        regex:  /active members/i,
        answer: "#{active_members} are active members."
      },
      {
        regex:  /most active/i,
        answer: "#{activist} is the activist of the week."
      }
    ]


    bot_correct_answers = bot_answers.map do |bot_answer|
      bot_answer[:answer] if @user_question =~ bot_answer[:regex]
    end

    bot_correct_answers = bot_correct_answers.select { |bot_answer| !bot_answer.nil? }

    if !bot_correct_answers.empty?
      bot_correct_answers.join("\n")
    else
      "Sorry, I did not understand the question ^^.\nTry again ..."
    end
  end

  def activist
    "#{KpiDash.new(@group, 'activist').call[:user].first_name} #{KpiDash.new(@group, 'activist').call[:user].last_name}"
  end

  def active_members
    "#{KpiDash.new(@group, 'members_ratio').call} %"
  end
end

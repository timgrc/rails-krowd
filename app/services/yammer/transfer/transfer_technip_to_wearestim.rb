require 'csv'
require 'yammer'

class Yammer::Transfer::TransferTechnipToWearestim
  def initialize

    # Groups
    test_group       = Group.find_by_full_name('Innovation challenge test')
    # @challenge_group = Group.find_by_full_name('Innovation Challenge Wagon')
    @challenge_group = test_group

    # Technip user
    @technip_user = User.find_by_email('cmenard@external.technip.com')

    # Wearestim users
    wearestim_usernames = [
      'hello',
      'timothee.garcia',
      'jeremy',
      'mathilde',
      'chloe.poudens',
      'melanie.mehat',
      'benjamin.duban',
      'colette.menard',
      'simon.martin',
      'anne-marjolaine.colson',
      'hendrik.jehle',
      'olga.kokshagina',
      'frederic.arnoux'
    ]

    @wearestim_users = wearestim_usernames.map do |username|
      {
        wearestim_user:         User.find_by_email("#{username}@wearestim.com"),
        assoc_technip_users_id: []
      }
    end
  end

  def call
    associate_technip_to_wearestim_users
    post_technip_messages_on_wearestim
  end

  private

  def associate_technip_to_wearestim_users

    # Order Technip users by number of messages
    csv_options = { col_sep: ',', headers: :first_row }
    filepath    = 'app/services/yammer/transfer/technip_export.csv'

    @technip_messages_id = []
    count_messages      = {}

    CSV.foreach(filepath, csv_options) do |row|
      rse_message_id    = row['id'].to_i
      rse_replied_to_id = row['replied_to_id']
      rse_sender_id     = row['sender_id'].to_i

      @technip_messages_id.push(rse_message_id)

      if !rse_replied_to_id.nil? && count_messages.key?(rse_sender_id)
        count_messages[rse_sender_id] += 1
      else
        count_messages[rse_sender_id] = 1
      end
    end

    count_messages = count_messages.sort_by { |_, count| count }.reverse!

    # Assign technip users to wearestim users
    @wearestim_users_without_bot = @wearestim_users[1...@wearestim_users.size]

    @assoc_next_turn = @wearestim_users_without_bot.size - 1

    count_messages.each do |user_id, _|
      @assoc_next_turn = assoc_turn @assoc_next_turn
      @wearestim_users_without_bot[@assoc_next_turn][:assoc_technip_users_id].push user_id
    end
  end

  def post_technip_messages_on_wearestim
    # Get all messages
    [669107552].each_with_index do |message_id, index|
    # technip_messages_id.each_with_index do |message_id, index|
      # 669009942 post
      # 669037310 comment with attchment

      technip_message = Yammer::GetMessage.new(@technip_user, message_id).call
      technip_sender = Yammer::GetTechnipUser.new(@technip_user, technip_message[:sender_id]).call
      @opts = { group_id: @challenge_group.rse_group_id }

      message_body = generate_message_body(technip_message[:sender_id], technip_message[:body], technip_message[:notified_user_ids])

      if technip_message[:replied_to_id].nil?
        # Post - Thread
        wearestim_sender = @wearestim_users.first[:wearestim_user]
        technip_thread   = Yammer::GetThread.new(@technip_user, technip_message[:id]).call
        get_topics(technip_thread[:topics])

      else
        #Comment
        @assoc_next_turn = assoc_turn @assoc_next_turn
        wearestim_sender = @wearestim_users_without_bot[@assoc_next_turn][:wearestim_user]
      end

      # Send the message
      # Yammer::PostMessage.new(
      #   wearestim_sender,
      #   message_body,
      #   @opts
      # ).call

      # Like the message
      Yammer::LikeMessage.new(
        wearestim_sender,
        812623339
      ).call
    end



    # Yammer::PostMessage.new(
    #   @wearestim_users.first[:wearestim_user],
    #   "test topic tim",
    #   group_id: @challenge_group.rse_group_id,
    #   topic1: 'tim'
    # ).call

    # like


  end

  def assoc_turn(turn)
    turn == @wearestim_users_without_bot.size - 1 ? 0 : turn + 1
  end

  def wearestim_user_associated(user_id)
    assoc_technip_users = @wearestim_users_without_bot.map do |wearestim_user|
      wearestim_user[:assoc_technip_users_id]
    end

    assoc_technip_users = assoc_technip_users.flatten

    if assoc_technip_users.include? user_id
      wearestim_user = @wearestim_users_without_bot.select do |wearestim_user|
        wearestim_user[:assoc_technip_users_id].include? user_id
      end
      wearestim_user.first[:wearestim_user]
    else
      @assoc_next_turn = assoc_turn @assoc_next_turn
      @wearestim_users_without_bot[@assoc_next_turn][:assoc_technip_users_id].push user_id
      @wearestim_users_without_bot[@assoc_next_turn][:wearestim_user]
    end
  end

  def convert_tag_in_message

  end

  def generate_message_body(sender_id, message_body, cc)
    res_message_body     = message_body[:plain]
    cc_in_message_array  = generate_body_with_cc_converted_in(message_body[:parsed])
    cc_out_message_array = generate_body_with_cc_converted_out(cc)
    cc_message_array     = (cc_in_message_array + cc_out_message_array).uniq

    unless cc_message_array.empty?
      message_body     = convert_notified_user_in_message_body(message_body[:plain])
      @opts[:cc]       = convert_notified_user_in_cc(cc)
      res_message_body = "#{message_body}\ncc: #{cc_message_array.join(', ')}"
    end

    "#{hash_tag_technip_user(sender_id)}: #{res_message_body}"
  end

  def convert_notified_user_in_cc(cc)
    cc.map do |notified_user_id|
      wearestim_user_associated(notified_user_id).rse_user_id
    end
  end

  def convert_notified_user_in_message_body(message_body)
    res = message_body

    message_body.scan(/\[\[user:(\d+)\]\]/).each do |user_id_array|
      user_id = user_id_array.first
      user    = Yammer::GetTechnipUser(user_id)
      assoc_wearestim_id = wearestim_user_associated(user_id).rse_user_id

      res = res.gsub(
        /#{user.first_name} #{user.last_name}/,
        "[[user:#{assoc_wearestim_id}]] | #{hash_tag_technip_user(user_id)}"
      )
    end

    res
  end

  def generate_body_with_cc_end_message(message_body_with_cc_converted_in_message, cc)
    @message_body = "#{@message_body}\ncc: #{cc_end_message.join(', ')}"
  end

  def generate_body_with_cc_converted_in(message_body)
    message_body.scan(/\[\[user:(\d+)\]\]/).map do |user_id_array|
      hash_tag_technip_user(user_id_array.first.to_i)
    end
  end

  def generate_body_with_cc_converted_out(cc)
    cc.map do |notified_user_id|
      hash_tag_technip_user(notified_user_id)
    end
  end

  def hash_tag_technip_user(technip_user_id)
    technip_user = Yammer::GetTechnipUser.new(@technip_user, technip_user_id).call
    "##{technip_user[:first_name].sub(' ', '_').downcase}_#{technip_user[:last_name].sub(' ', '_').downcase}"
  end

  def get_topics(topics)
    unless topics.empty?
      topics_name = topics.map { |topic| Yammer::GetTopic.new(@technip_user, topic.to_i).call }.uniq
      topics_name.each_with_index do |topic_name, index|
        @opts["topic#{index + 1}".to_sym] = topic_name
      end
    end
  end
end

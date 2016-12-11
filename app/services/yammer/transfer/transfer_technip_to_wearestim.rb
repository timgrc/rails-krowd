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
    [669009942].each_with_index do |message_id, index|
    # technip_messages_id.each_with_index do |message_id, index|

      technip_message  = Yammer::GetMessage.new(@technip_user, message_id).call
      liked_by_message = Yammer::GetLikesFromMessage.new(@technip_user, message_id).call
      @opts = { group_id: @challenge_group.rse_group_id }

      message_body = generate_message_body(
        technip_message[:sender_id],
        technip_message[:body],
        technip_message[:notified_user_ids],
        liked_by_message
      )

      p technip_message[:attachments] ## WORK IN PROGRESS
      next

      if technip_message[:replied_to_id].nil?
        # Post - Thread
        wearestim_sender = @wearestim_users.first[:wearestim_user]
        technip_thread   = Yammer::GetThread.new(@technip_user, technip_message[:id]).call
        get_topics(technip_thread[:topics])

      else
        #Comment
        @assoc_next_turn = assoc_turn @assoc_next_turn
        wearestim_sender = @wearestim_users_without_bot[@assoc_next_turn][:wearestim_user]
        # @opts[:replied_to_id] = 1
      end

      # Attachments
      attachment = RestClient::Resource.new("https://www.yammer.com/api/v1/uploaded_files/76267736/download")
      response = attachment.get(authorization: "Bearer #{@wearestim_users.first[:wearestim_user].access_token}")
      File.write('image.jpg', response, mode: 'wb')

      @opts[:attachment1] = File.open('image.jpg')

      # Send the message
      Yammer::PostMessage.new(
        wearestim_sender,
        message_body,
        @opts
      ).call

      # Message sent
      # message_sent = Yammer::GetLastMessageFromGroup.new(
      #   @wearestim_users.first[:wearestim_user],
      #   @challenge_group.rse_group_id
      # ).call

      # Like the message
      # assocs_likes_message = post_like_to_message(technip_message[:id], liked_by_message)
      # assocs_likes_message.each do |assoc_like|
      #   Yammer::LikeMessage.new(assoc_like, message_sent[:id]).call
      # end
    end
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

  def generate_message_body(sender_id, message_body, cc, liked_by)
    cc_text              = ''
    likes_text           = ''
    cc_in_message_array  = generate_body_with_cc_converted_in(message_body[:parsed])
    cc_out_message_array = generate_body_with_cc_converted_out(cc)
    cc_message_array     = (cc_in_message_array + cc_out_message_array).uniq

    liked_by_technip_users_text = liked_by_technip_users(liked_by)

    res_message_body = convert_notified_user_in_message_body(message_body[:plain], message_body[:parsed])

    unless cc_message_array.empty?
      @opts[:cc]       = convert_notified_user_in_cc(cc)
      cc_text = "\ncc: #{cc_message_array.join(', ')}"
    end

    res_message_body = " #{res_message_body}"

    unless liked_by_technip_users_text.nil?
      likes_text = liked_by_technip_users_text
    end

    unless cc_message_array.empty? && liked_by_technip_users_text.nil?
      "#{hash_tag_technip_user(sender_id)}: #{res_message_body}\n\nTechnip Innovation Challenge data:#{cc_text}#{likes_text}"
    else
      message_body[:plain]
    end
  end

  def convert_notified_user_in_cc(cc)
    cc.map do |notified_user_id|
      wearestim_user_associated(notified_user_id).rse_user_id
    end
  end

  def convert_notified_user_in_message_body(message_body_plain, message_body_parsed)
    res = message_body_plain

    message_body_parsed.scan(/\[\[user:(\d+)\]\]/).each do |user_id_array|
      user_id = user_id_array.first.to_i
      user    = Yammer::GetTechnipUser.new(@technip_user, user_id).call
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
      topics_name = topics.map { |topic| Yammer::GetTopic.new(@technip_user, topic).call }.uniq
      topics_name.each_with_index do |topic_name, index|
        @opts["topic#{index + 1}".to_sym] = topic_name[:normalized_name]
      end
    end
  end

  def liked_by_technip_users(liked_by)
    liked_by_array = liked_by.map do |like|
      hash_tag_technip_user(like[:id])
    end

    unless liked_by_array.empty?
      likes_text = liked_by_array.count > 1 ? "likes:" : "like:"
      "\n#{likes_text} #{liked_by_array.join(', ')}"
    end
  end

  def post_like_to_message(message_id, liked_by)
    liked_by.map do |like|
      wearestim_user_associated(like[:id])
    end
  end
end

require 'csv'

class Yammer::Transfer::TransferTechnipToWearestim
  def initialize

    # Technip user
    @technip_user = User.find_by_email('cmenard@external.technip.com')

    # Wearestim users
    wearestim_usernames = [
      'hello',
      'timothee.garcia',
      'jeremy',
      'mathilde',
      # 'chloe.poudens',
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
  end

  private

  def associate_technip_to_wearestim_users

    # Order Technip users by number of messages
    csv_options = { col_sep: ',', headers: :first_row }
    filepath    = 'app/services/yammer/transfer/technip_export.csv'

    technip_messages_id = []
    count_messages      = {}

    CSV.foreach(filepath, csv_options) do |row|
      rse_message_id    = row['id'].to_i
      rse_replied_to_id = row['replied_to_id']
      rse_sender_id     = row['sender_id'].to_i

      technip_messages_id.push(rse_message_id)

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

    # Get all messages
    Yammer::GetMessage.new(@technip_user, technip_messages_id.first).call





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
end

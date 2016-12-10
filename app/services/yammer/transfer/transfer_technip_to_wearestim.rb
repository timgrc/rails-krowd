require 'csv'

class Yammer::Transfer::TransferTechnipToWearestim
  def initialize

    #Technip user
    @technip_user = User.find_by_email('cmenard@external.technip.com')

    #Wearestim users
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
    @wearestim_users

  end
end


# csv_options = { col_sep: ',', headers: :first_row }
# filepath    = 'db/fixtures/technip_export.csv'

# rse_messages_id = []

# CSV.foreach(filepath, csv_options) do |row|
#   rse_message_id = row['id'].to_i
#   # Yammer::GetMessage.new(technip_user, rse_messages_id).call
# end

# {
#   keyword: '/wagon/',
#   assoc_message: 'Welcome to the Wagon !'
# }

# p Kpi::CountActiveMembers.new.call

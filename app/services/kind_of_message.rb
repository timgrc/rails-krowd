require 'csv'

class KindOfMessage
  def initialize(message)
    @message = message.downcase
  end

  def call
    csv_options = { col_sep: ',', headers: :first_row }
    filepath    = 'app/services/kind_of_message.csv'

    CSV.foreach(filepath, csv_options) do |row|
      keywords = row['keywords'].downcase
      kind     = row['kind']

      return kind if @message.match(/#{keywords}/)
    end
  end
end

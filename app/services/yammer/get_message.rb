require 'yammer'

class Yammer::GetMessage
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    rse_message = @yam.get_message(@message_id).body
    # rse_message.select ... #on sélectionne les clés dont on a besoin
    # id
    # sender_id
    # replied_to_id
    # body [:message]
    # cc
    # topic
    # hashtag
    # @
    # attachments
  end
end

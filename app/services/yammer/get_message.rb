require 'yammer'

class Yammer::GetMessage
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    message =  @yam.get_message(@message_id).body
    message_keys_needed = [
      :id,
      :sender_id,
      :replied_to_id,
      :created_at,
      :web_url,
      :group_id,
      :body,
      :thread_id,
      :notified_user_ids,
      :attachments,
      :liked_by
    ]

    message.select { |key, _| message_keys_needed.include? key }
    message[:plain]  = message[:body][:plain]
    message[:parsed] = message[:body][:parsed]
    message.delete(:body)

    message
  end
end

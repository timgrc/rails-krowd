class Yammer::GetThread
  def initialize(user, message_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @message_id = message_id
  end

  def call
    thread = @yam.get_thread(@message_id).body
    thread_keys_needed = [
      :id,
      :group_id,
      :stats,
      :web_url,
      :topics,
    ]
    thread.select { |key, _| thread_keys_needed.include? key }
    thread[:topics] = thread[:topics].map { |topic| topic[:id] }

    thread[:updates]         = thread[:stats][:updates]
    thread[:first_reply_id]  = thread[:stats][:first_reply_id]
    thread[:latest_reply_id] = thread[:stats][:latest_reply_id]
    thread.delete(:updates)

    thread
  end
end

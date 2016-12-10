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
      :topics
    ]
    thread.select { |key, _| thread_keys_needed.include? key }
    thread[:topics] = thread[:topics].map { |topic| topic[:id] }

    thread
  end
end

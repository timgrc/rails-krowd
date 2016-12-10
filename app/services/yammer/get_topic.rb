class Yammer::GetTopic
  def initialize(user, topic_id)
    @yam      = Yammer::Client.new(access_token: user.access_token)
    @topic_id = topic_id
  end

  def call
    topic = @yam.get_topic(@topic_id).body
  end
end

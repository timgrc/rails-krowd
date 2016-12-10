class Yammer::PostMessage
  def initialize(user, message, opts = {})
    @yam     = Yammer::Client.new(access_token: user.access_token)
    @message = message
    @opts    = opts
  end

  def call
    @yam.create_message @message, @opts
  end
end

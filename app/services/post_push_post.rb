require 'yammer'

class PostPushPost
  def initialize(user, push_post)
    @yam = Yammer::Client.new(access_token: user.access_token)
    @push
  end

  def call
    @yam.create_message(

    )
  end
end

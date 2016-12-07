require 'yammer'

class GetPostsFromGroup
  def initialize(user)
    @yam = Yammer::Client.new(access_token: user.access_token)
  end
end

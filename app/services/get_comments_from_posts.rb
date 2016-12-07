require 'yammer'

class GetCommentsFromPosts
  def initialize(user)
    @yam = Yammer::Client.new(access_token: user.access_token)
  end

  def list

  end
end

class Yammer::GetPostsFromGroup
  def initialize(user)
    @yam = Yammer::Client.new(access_token: user.access_token)
  end

  def call
  end
end

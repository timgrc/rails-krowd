class GetCommentsFromPosts
  def initialize(user)
    @yam = Yammer::Client.new(access_token: user_access_token)
  end
end

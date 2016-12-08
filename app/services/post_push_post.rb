class PostPushPost
  def initialize(user, group, push_post, replied_to_rse_id = nil)
    @yam           = Yammer::Client.new(access_token: user.access_token)
    @group         = group
    @push_post     = push_post
    @replied_to_id = replied_to_rse_id
  end

  def call
    opts = {
      group_id: @group.rse_group_id
    }
    opts[:replied_to_id] = @replied_to_id if @replied_to_id

    @yam.create_message @push_post.body, opts
  end
end

class Yammer::GetLastMessageFromGroup
  def initialize(user, group_id)
    @yam       = user
    @group_id  = group_id
  end

  def call
    Yammer::GetMessagesFromGroup.new(@yam, @group_id).call.first
  end
end

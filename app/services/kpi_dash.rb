class KpiDash
  def initialize(group, kpi)
    @group = group
    @kpi   = kpi
  end

  def call
    case @kpi
    when 'members'
      [members[:active], members[:inactive]]
    when 'members_ratio'
      members[:ratio]
    when 'members_active'
      members[:active]
    when 'likes'
      likes
    when 'comments'
      comments
    when 'top3_departments_data'
      top3_departments[:data]
    when 'top3_departments_labels'
      top3_departments[:labels]
    when 'influencer'
      influencer
    when 'activist'
      activist
    when 'networker'
      networker
    when 'inventor'
      inventor
    when 'mastermind'
      mastermind
    when 'countries'
      countries

#     when 'kext'

#     when ''

    end
  end

  def members
    active = User.
      joins(:messages, :groups).
      where('groups.id=1 and messages.rse_replied_to_id is not null').
      group('users.id').
      count.count

    inactive = @group.total_members - active
    ratio = (100 * active.to_f / @group.total_members).round
    {
      active: active,
      inactive: inactive,
      ratio: ratio
    }
  end

  def likes
    Message.joins(thread_post: :group)
           .where('messages.replied_to_id is not null and groups.id=?', @group.id)
           .sum(:liked_by)
  end

  def comments
    Message.joins(thread_post: :group)
           .where('messages.replied_to_id is not null and groups.id=?', @group.id)
           .count
  end

  def top3_departments
    departments = User.joins(:groups).
                      where('users.email != ? and groups.id = ?', 'hello@wearestim.com', @group.id).
                      group(:department).
                      order('count_all desc').
                      limit(3).
                      count

    {
      data: departments.values,
      labels: departments.keys
    }
  end

  def influencer
   influencing_message_id = Message.
      joins(:group).
      where('groups.id=? and replied_to_id is not null', @group.id).
      group('messages.replied_to_id').
      order('count_all desc').
      count.
      find { |key, _| Message.find(key).replied_to_id != nil }

    influencing_message = Message.find(influencing_message_id.first)

    @influencer = influencing_message.user

    {
      message: influencing_message,
      user: influencing_message.user,
      likes: influencing_message.liked_by,
      comments: influencing_message_id.last
    }

  end

  def activist
    influencer

    activists = Message.joins(:group, :user).
                       where('replied_to_id is not null and groups.id = ? and users.id != ?', @group.id, @influencer.id ).
                       group('users.id').
                       order('count_all desc').
                       limit(1).
                       count

    @activist = User.find(activists.keys.first)

    {
      user: @activist,
      comments: activists.values.first
    }
  end

  def networker
    influencer
    activist

    networkers = Message.joins(:group, :user).
                       where('replied_to_id is not null and groups.id = ? and users.id != ? and users.id != ?', @group.id, @influencer.id, @activist.id ).
                       group('users.id').
                       order('sum_notified_by desc').
                       limit(1).
                       sum('notified_by')

    @networker = User.find(networkers.keys.first)

    {
      user: @networker,
      notified_by: networkers.values.first
    }
  end

  def inventor
    influencer
    activist
    networker

    inventors = User.joins(:messages, :groups).
        where('replied_to_id is not null and groups.id = ? and idea_kint_kext_social=? and users.id != ? and users.id != ? and users.id != ?', @group.id, 'idea', @influencer.id, @activist.id, @networker.id).
        group('users.id').
        order('count_all desc').
        limit(1).
        count

    @inventor = User.find(inventors.keys.first)

    {
      user: @inventor,
      ideas: inventors.values.first
    }
  end

  def mastermind
    influencer
    activist
    networker
    inventor

    masterminds = User.joins(:messages, :groups).
        where('replied_to_id is not null and groups.id = ? and (idea_kint_kext_social=? or idea_kint_kext_social=?) and users.id != ? and users.id != ? and users.id != ? and users.id != ?', @group.id, 'kint', 'kext', @influencer.id, @activist.id, @networker.id, @inventor.id).
        group('users.id').
        order('count_all desc').
        limit(1).
        count

    @mastermind = User.find(masterminds.keys.first)

    {
      user: @mastermind,
      knowledges: masterminds.values.first
    }
  end

  def countries
    User.joins(:groups, :messages).
      where('replied_to_id is not null and groups.id = ?', @group.id).
      group('location').
      order('count_all desc').
      count



  end
end

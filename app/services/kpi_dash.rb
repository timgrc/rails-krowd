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
    when 'organisation_business'
      organisation_business
    when 'organisation_technology'
      organisation_technology
    when 'innovation_ideas'
      innovation_ideas
    when 'innovation_kint'
      innovation_kint
    when 'innovation_kext'
      innovation_kext
    end
  end

  def members
    active = User.
      joins(:messages, :groups).
      where('groups.id=? and messages.rse_replied_to_id is not null', @group.id).
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
    countries = User.joins(:groups, :messages).
      where('replied_to_id is not null and groups.id = ?', @group.id).
      group('location').
      order('count_all desc').
      count

    [['Country', 'Active Members']] + countries.map { |country, active_members| [country, active_members]}
  end

  def organisation_business
    likes = Message.joins(:group, :thread_post).
              where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'business').
              sum('liked_by')

    comments = Message.joins(:group, :thread_post).
              where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'business').
              count

    thread_business1 = Message.where("plain LIKE '%Post2 Week1%'").first
    thread_business1_countries = User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business1.thread_post.id)
      .group('location').count.count
    thread_business1_departments = User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business1.thread_post.id)
      .group('department').count.count

    thread_business2 = Message.where("plain LIKE '%Post10 Week1%'").first
    thread_business2_countries = thread_business1_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business2.thread_post.id)
      .group('location').count.count
    thread_business2_departments = thread_business1_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business2.thread_post.id)
      .group('department').count.count

    thread_business3 = Message.where("plain LIKE '%Post13 Week2%'").first
    thread_business3_countries = thread_business2_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business3.thread_post.id)
      .group('location').count.count
    thread_business3_departments = thread_business2_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business3.thread_post.id)
      .group('department').count.count

    thread_business4 = Message.where("plain LIKE '%Post24 Week3%'").first
    thread_business4_countries = thread_business3_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business4.thread_post.id)
      .group('location').count.count
    thread_business4_departments = thread_business3_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business4.thread_post.id)
      .group('department').count.count


    {
      likes_comments: [likes, comments],
      departments: [thread_business1_departments, thread_business2_departments, thread_business3_departments, thread_business4_departments],
      countries:   [thread_business1_countries, thread_business2_countries, thread_business3_countries, thread_business4_countries],
    }
  end

  def organisation_technology
    likes = Message.joins(:group, :thread_post).
          where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'technology').
          sum('liked_by')

    comments = Message.joins(:group, :thread_post).
          where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'technology').
          count

    thread_technology1 = Message.where("plain LIKE '%Post4 Week1%'").first
    thread_technology1_countries = User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology1.thread_post.id)
      .group('location').count.count
    thread_technology1_departments = User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology1.thread_post.id)
      .group('department').count.count

    thread_technology2 = Message.where("plain LIKE '%Post14 Week2%'").first
    thread_technology2_countries = thread_technology1_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology2.thread_post.id)
      .group('location').count.count
    thread_technology2_departments = thread_technology1_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology2.thread_post.id)
      .group('department').count.count

    thread_technology3 = Message.where("plain LIKE '%Post15 Week2%'").first
    thread_technology3_countries = thread_technology2_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.id = ?', @group.id, thread_technology3.thread_post.id)
      .group('location').count.count
    thread_technology3_departments = thread_technology2_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology3.thread_post.id)
      .group('department').count.count

    thread_technology4 = Message.where("plain LIKE '%Post22 Week3%'").first
    thread_technology4_countries = thread_technology3_countries + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology4.thread_post.id)
      .group('location').count.count
    thread_technology4_departments = thread_technology3_departments + User.joins(:groups, :thread_posts, :messages).
      where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology4.thread_post.id)
      .group('department').count.count

    {
      likes_comments: [likes, comments],
      departments: [thread_technology1_departments, thread_technology2_departments, thread_technology3_departments, thread_technology4_departments],
      countries:   [thread_technology1_countries, thread_technology2_countries, thread_technology3_countries, thread_technology4_countries],
    }
  end

  def innovation_ideas
    business_ideas = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'idea', 'business').
      group('thread_posts.innovation_disruption').
      count

    technology_ideas = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'idea', 'technology').
      group('thread_posts.innovation_disruption').
      count

    [
      business_ideas["innovation"],
      business_ideas["disruption"],
      technology_ideas["innovation"],
      technology_ideas["disruption"]
    ]
  end

  def innovation_kint
    business_kint = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'kint', 'business').
      group('thread_posts.innovation_disruption').
      count

    technology_kint = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'kint', 'technology').
      group('thread_posts.innovation_disruption').
      count

    [
      business_kint["innovation"],
      business_kint["disruption"],
      technology_kint["innovation"],
      technology_kint["disruption"]
    ]
  end

  def innovation_kext
    business_kext = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'kext', 'business').
      group('thread_posts.innovation_disruption').
      count

    technology_kext = Message.joins(:group, :thread_post).
      where('replied_to_id is not null and groups.id = ? and messages.idea_kint_kext_social = ? and thread_posts.business_technology = ?', @group.id, 'kext', 'technology').
      group('thread_posts.innovation_disruption').
      count

    [
      business_kext["innovation"],
      business_kext["disruption"],
      technology_kext["innovation"],
      technology_kext["disruption"]
    ]
  end
end

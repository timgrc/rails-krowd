class KpiDash
  def initialize(group, kpi)
    @group = group
    @kpi   = kpi
  end

  def call
    case @kpi
    when 'members'
      {
        active: members[:active],
        inactive: members[:inactive]
      }
    when 'members_ratio'
      members[:ratio]
    when 'members_active'
      members[:active]
    when 'likes'
      likes
    when 'comments'
      comments
    when 'departments'
      departments
    when 'countries'
      countries
    when 'last_business_wi'
      last_business_wi
    when 'last_technology_wi'
      last_technology_wi
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

  def departments
    departments_active_members = User.joins(:groups).
                                 where('users.email != ? and groups.id = ?', 'hello@wearestim.com', @group.id).
                                 group(:department).
                                 order('count_all desc').
                                 count

    departments_comments = User.joins(:groups, :messages).
                           where('users.email != ? and groups.id = ?', 'hello@wearestim.com', @group.id).
                           group(:department).
                           order('count_all').
                           count

    departments_data = departments_active_members.map do |department, nb_active_members|
      {
        name: department,
        active_members: nb_active_members,
        comments: departments_comments[department]
      }
    end

    p departments_data
  end

  def countries
    countries_active_members = User.joins(:groups).
      where('users.email != ? and groups.id = ?', 'hello@wearestim.com', @group.id).
      group('location').
      order('count_all desc').
      count

    countries_comments = User.joins(:groups, :messages).
      where('replied_to_id is not null and groups.id = ?', @group.id).
      group('location').
      order('count_all desc').
      count

    countries_data = countries_comments.map do |country, nb_comments|
      {
        name: country,
        active_members: countries_active_members[country],
        comments: nb_comments
      }
    end

    p countries_data
  end

  def last_business_wi
    Message.joins(:group, :thread_post).
      where('replied_to_id is null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'business').
      order('id desc').
      limit(1).
      first[:plain]
  end

  def last_technology_wi
    Message.joins(:group, :thread_post).
      where('replied_to_id is null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'technology').
      order('id desc').
      limit(1).
      first[:plain]
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
        where("replied_to_id is not null and groups.id = ? and (idea_kint_kext_social='kint' or idea_kint_kext_social='kext') and users.id != ? and users.id != ? and users.id != ? and users.id != ?", @group.id, @influencer.id, @activist.id, @networker.id, @inventor.id).
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

  def organisation_business
    likes = Message.joins(:group, :thread_post).
              where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'business').
              sum('liked_by')

    comments = Message.joins(:group, :thread_post).
              where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'business').
              count

    # thread_business1 = Message.where("plain LIKE '%Post2 Week1%'").first
    # thread_business1_countries = User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business1.thread_post.id)
    #   .group('location').count

    # thread_business1_departments = User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business1.thread_post.id)
    #   .group('department').count

    # thread_business1_countries   = thread_business1_countries.select { |country, comments| comments != 0 }
    # thread_business1_departments = thread_business1_departments.select { |department, comments| comments != 0 }

    # TO BE CONTINUED

    # thread_business1_countries = User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business1.thread_post.id)
    #   .group('location').count.count

    # thread_business2 = Message.where("plain LIKE '%Post10 Week1%'").first
    # thread_business2_countries = thread_business1_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business2.thread_post.id)
    #   .group('location').count.count
    # thread_business2_departments = thread_business1_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business2.thread_post.id)
    #   .group('department').count.count

    # thread_business3 = Message.where("plain LIKE '%Post13 Week2%'").first
    # thread_business3_countries = thread_business2_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business3.thread_post.id)
    #   .group('location').count.count
    # thread_business3_departments = thread_business2_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business3.thread_post.id)
    #   .group('department').count.count

    # thread_business4 = Message.where("plain LIKE '%Post24 Week3%'").first
    # thread_business4_countries = thread_business3_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business4.thread_post.id)
    #   .group('location').count.count
    # thread_business4_departments = thread_business3_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'business', thread_business4.thread_post.id)
    #   .group('department').count.count


    {
      likes: likes,
      comments: comments,
      what_ifs: ['Post2 Week1', 'Post10 Week1', 'Post13 Week2', 'Post24 Week3'],
      countries:   [1, 3, 3, 4],
      departments: [1, 2, 4, 5],
      # countries:   [thread_business1_countries.count, thread_business1_countries.count, thread_business1_countries.count, thread_business1_countries.count],
      # departments: [thread_business1_departments.count, thread_business1_departments.count, thread_business1_departments.count, thread_business1_departments.count],
    }
  end

  def organisation_technology
    likes = Message.joins(:group, :thread_post).
          where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'technology').
          sum('liked_by')

    comments = Message.joins(:group, :thread_post).
          where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ?', @group.id, 'technology').
          count

    # thread_technology1 = Message.where("plain LIKE '%Post4 Week1%'").first
    # thread_technology1_countries = User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology1.thread_post.id)
    #   .group('location').count.count
    # thread_technology1_departments = User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology1.thread_post.id)
    #   .group('department').count.count

    # thread_technology2 = Message.where("plain LIKE '%Post14 Week2%'").first
    # thread_technology2_countries = thread_technology1_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology2.thread_post.id)
    #   .group('location').count.count
    # thread_technology2_departments = thread_technology1_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology2.thread_post.id)
    #   .group('department').count.count

    # thread_technology3 = Message.where("plain LIKE '%Post15 Week2%'").first
    # thread_technology3_countries = thread_technology2_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.id = ?', @group.id, thread_technology3.thread_post.id)
    #   .group('location').count.count
    # thread_technology3_departments = thread_technology2_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology3.thread_post.id)
    #   .group('department').count.count

    # thread_technology4 = Message.where("plain LIKE '%Post22 Week3%'").first
    # thread_technology4_countries = thread_technology3_countries + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology4.thread_post.id)
    #   .group('location').count.count
    # thread_technology4_departments = thread_technology3_departments + User.joins(:groups, :thread_posts, :messages).
    #   where('replied_to_id is not null and groups.id = ? and thread_posts.business_technology = ? and thread_posts.id = ?', @group.id, 'technology', thread_technology4.thread_post.id)
    #   .group('department').count.count

    {
      likes: likes,
      comments: comments,
      what_ifs: ['Post4 Week1', 'Post14 Week2', 'Post15 Week2', 'Post22 Week3'],
      departments: [1, 3, 5, 5],
      countries:   [2, 3, 4, 4]
      # departments: [thread_technology1_departments, thread_technology2_departments, thread_technology3_departments, thread_technology4_departments],
      # countries:   [thread_technology1_countries, thread_technology2_countries, thread_technology3_countries, thread_technology4_countries],
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

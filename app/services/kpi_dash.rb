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
#     when 'kint'

#     when 'kext'

#     when ''

    end
  end

  def members
    active = User.joins(:messages)
                 .where('messages.replied_to_id!=?', 0)
                 .group('users.id')
                 .count

    active = active.select do |user_id, _|
      User.find(user_id).groups.include? @group
    end

    active = active.count

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
           .where('messages.replied_to_id!=? and groups.id=?', 0, @group.id)
           .sum(:liked_by)
  end

  def comments
    Message.joins(thread_post: :group)
           .where('messages.replied_to_id!=? and groups.id=?', 0, @group.id)
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
    messages = Message.joins(:group).
                      where('replied_to_id != 0 and groups.id = ?', @group.id)

    messages = messages.map do |message|
      messages_replied = messages.count { |message_selected| message_selected.replied_to_id == message.id }
      {
        message: message,
        user: message.user,
        likes: message.liked_by,
        comments: messages_replied
      }
    end


    influencing_message = messages.max_by do |message|
      message[:likes] + message[:comments]
    end

    @influencer = influencing_message[:user]

    influencing_message
  end

  def activist
    influencer

    activists = Message.joins(:group, :user).
                       where('replied_to_id != 0 and groups.id = ? and users.id != ?', @group.id, @influencer.id ).
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
                       where('replied_to_id != 0 and groups.id = ? and users.id != ? and users.id != ?', @group.id, @influencer.id, @activist.id ).
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
        where('replied_to_id != 0 and groups.id = ? and idea_kint_kext_social=? and users.id != ? and users.id != ? and users.id != ?', @group.id, 'idea', @influencer.id, @activist.id, @networker.id).
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
        where('replied_to_id != 0 and groups.id = ? and (idea_kint_kext_social=? or idea_kint_kext_social=?) and users.id != ? and users.id != ? and users.id != ? and users.id != ?', @group.id, 'kint', 'kext', @influencer.id, @activist.id, @networker.id, @inventor.id).
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

#   end

#   def badges
#     badges = {}
#     # 1- The activist - The one who commented the most
#

#     activists.map { |key, _| User.find(key) }


#     3- The inventor - Celui qui a le plus posté d'idées
#     inventors = User.joins(:messages)
#                       .where('messages.rse_replied_to_id!=? and messages.idea_kint_kext_social=?', 0, 'idea')
#                       .group('users.id')
#                       .order('count_all desc')
#                       .count

#     p inventors.map { |key, _| User.find(key) }

#     4- The mastermind - Celui qui a posté le plus de K
#     masterminds = User.joins(:messages)
#                         .where('messages.rse_replied_to_id!=? and (messages.idea_kint_kext_social=? or messages.idea_kint_kext_social=?)', 0, 'kint', 'kext')
#                         .group('users.id')
#                         .order('count_all desc')
#                         .count

#     masterminds.map { |key, _| User.find(key) }


#     puts "Influencer : #{influencer.first_name}"
#     puts "#{influencing_message_hash[:liked]} likes and #{influencing_message_hash[:commented]} comments"
#     puts "Influencing message : #{influencing_message.plain}"
end

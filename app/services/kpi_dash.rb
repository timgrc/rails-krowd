class KpiDash
  def initialize(group, kpi)
    @group = group
    @kpi   = kpi
  end

  def call
    case @kpi
    when 'members'
      {

      }

#   when 'badges'

#     when 'ideas'

#     when 'kint'

#     when 'kext'

#     when ''

    end
#   end

#   def badges
#     badges = {}
#     # 1- The activist - The one who commented the most
#     activists = User.joins(:messages)
#                     .where('messages.rse_replied_to_id!=?', 0)
#                     .group('users.id')
#                     .order('count_all desc')
#                     .count

#     activists.map { |key, _| User.find(key) }

#     # 2- The networker - Celui qui a le plus notifié de personnes
#     networkers = User.joins(:messages)
#                       .where('messages.rse_replied_to_id!=?', 0)
#                       .group('users.id')
#                       .sum('notified_by')
#     p networkers.map { |key, _| User.find(key) }

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

#     5- The influencer - Celui qui a le post qui a été le plus (liké + commenté)
#     messages_without_thread_messages = Message.where('messages.rse_replied_to_id!=?', 0)

#     influencing_messages = messages_without_thread_messages.map do |message|
#       messages_replied = messages_without_thread_messages.select do |message_selected|
#         message.rse_id == message_selected.rse_replied_to_id
#       end
#       {
#         id:        message.id,
#         liked:     message.liked_by,
#         commented: messages_replied.count,
#       }
#     end

#     influencing_message_hash = influencing_messages.max_by do |message|
#       message[:liked] + message[:commented]
#     end
#     influencing_message = Message.find(influencing_message_hash[:id])
#     influencer          = influencing_message.user

#     puts "Influencer : #{influencer.first_name}"
#     puts "#{influencing_message_hash[:liked]} likes and #{influencing_message_hash[:commented]} comments"
#     puts "Influencing message : #{influencing_message.plain}"

  end
end

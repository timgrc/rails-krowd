# require 'yammer'

user  = User.find_by_email('hello@wearestim.com')
group = Group.find(1)

# User.all.each do |user|
#   mem = Membership.new
#   mem.user = user
#   mem.group = group
#   mem.save
# end

p KpiDash.new(group, 'influencer').call
# opts = {}
# yam = Yammer::Client.new(access_token: user.access_token)
# p yam.messages_in_thread(813963771, opts).body[:messages]

# Yammer::UpdateGroup.new(user, group).call

require 'yammer'

user  = User.find_by_email('hello@wearestim.com')
group = Group.find(3)

# opts = {}
# yam = Yammer::Client.new(access_token: user.access_token)
# p yam.messages_in_thread(813963771, opts).body[:messages]

# yam.
Yammer::UpdateGroup.new(user, group).call

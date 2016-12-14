user  = User.find_by_email('simon.martin@wearestim.com')
group = Group.find(2)

Yammer::UpdateGroup.new(user, group).call

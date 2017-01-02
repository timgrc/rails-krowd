it1 = IncentiveTemplate.new
it1.body = "Thank you guys for this awesome week! Keep going!"
it1.user = User.find_by_email('timothee.garcia@wearestim.com')
it1.group = Group.find_by_full_name('Innovation Challenge - The Company')
it1.save

# user = User.find_by_email('timothee.garcia@wearestim.com')
# group = Group.find_by_full_name('Innovation Challenge - The Company')

# Yammer::UpdateGroup.new(user, group).call

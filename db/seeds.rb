Membership.delete_all

User.all.each do |user|
  mem = Membership.new
  mem.user = user
  mem.group = Group.find_by_full_name('Innovation Challenge - The Company')
  mem.save
end

it1 = IncentiveTemplate.new
it1.body = "Thank you guys for this awesome week! Keep going!"
it1.user = User.find_by_email('timothee.garcia@wearestim.com')
it1.group = Group.find_by_full_name('Innovation Challenge - The Company')
it1.save

# user  = User.find_by_email('melanie.mehat@wearestim.com')
# group = Group.find(3)

# Yammer::UpdateGroup.new(user, group).call

msg = "#disrption #business coin coin coin coin"
inno = msg.match(/(#innovation|#disruption)/)
inno2 = msg.match(/(#business|#technology)/)

p inno.nil?
p inno2.nil?

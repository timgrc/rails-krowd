hello = User.find_by_email('hello@wearestim.com')
group = Group.find_by_full_name('Innovation Challenge Import')

Yammer::UpdateGroup.new(hello, group.rse_id.to_i).call

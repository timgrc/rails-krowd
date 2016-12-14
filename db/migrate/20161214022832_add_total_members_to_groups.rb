class AddTotalMembersToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :total_members, :integer
  end
end

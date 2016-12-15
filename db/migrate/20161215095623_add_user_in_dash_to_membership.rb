class AddUserInDashToMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :user_in_dash, :boolean, default: false
  end
end

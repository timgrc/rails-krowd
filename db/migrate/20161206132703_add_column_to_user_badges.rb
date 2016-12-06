class AddColumnToUserBadges < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_badges, :group, foreign_key: true
  end
end

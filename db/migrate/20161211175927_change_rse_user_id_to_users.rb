class ChangeRseUserIdToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :rse_user_id, :rse_id
  end
end

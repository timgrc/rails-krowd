class ChangeLatestRepliedIdInBotUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :bot_users, :latest_replied_id, :latest_rse_replied_id
  end
end

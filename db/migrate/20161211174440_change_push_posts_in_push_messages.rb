class ChangePushPostsInPushMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :push_posts, :title
    rename_table :push_posts, :push_messages
  end
end

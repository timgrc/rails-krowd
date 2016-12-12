class ChangePushPosts < ActiveRecord::Migration[5.0]
  def ChangePushPosts
    remove_column :push_posts, :title
    rename_table :push_posts, :push_messages
  end
end

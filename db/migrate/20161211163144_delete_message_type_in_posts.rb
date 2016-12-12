class DeleteMessageTypeInPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :message_type
    remove_column :posts, :rich
    remove_column :posts, :title
  end
end

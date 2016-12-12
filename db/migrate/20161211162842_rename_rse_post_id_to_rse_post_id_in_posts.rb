class RenameRsePostIdToRsePostIdInPosts < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :rse_post_id, :rse_id
  end
end

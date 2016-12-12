class RenamePostsIntoThreads < ActiveRecord::Migration[5.0]
  def change
    rename_table :posts, :threads
  end
end

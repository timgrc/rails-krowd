class RemoveThreads < ActiveRecord::Migration[5.0]
  def change
    rename_table :threads, :thread_posts
  end
end

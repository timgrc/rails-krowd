class ChangeColumnsInThread < ActiveRecord::Migration[5.0]
  def change
    remove_column :threads, :rse_created_at
    remove_column :threads, :plain
    remove_column :threads, :liked_by
    add_column :threads, :updates, :integer
    add_column :threads, :first_reply_id, :integer
    add_column :threads, :lastest_reply_id, :integer
  end
end

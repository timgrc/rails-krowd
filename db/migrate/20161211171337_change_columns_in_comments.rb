class ChangeColumnsInComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :rse_id, :integer
    add_column :comments, :rse_replied_to, :integer
    add_column :comments, :rse_created_at, :string
    add_column :comments, :web_url, :string
    add_column :comments, :parsed, :string
    remove_column :comments, :rich
    remove_column :comments, :liked_by
    add_column :comments, :liked_by, :integer
    add_column :comments, :notified_by, :integer
  end
end

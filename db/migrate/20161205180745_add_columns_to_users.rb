class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rse_user_id, :integer
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :job_title, :string
    add_column :users, :contact, :string
    add_column :users, :timezone, :string
    add_column :users, :location, :string
    add_column :users, :department, :string
    add_column :users, :expertise, :string
    add_column :users, :mugshot_url, :string
    add_column :users, :admin, :boolean
  end
end

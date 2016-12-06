class AddInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_token, :string
    add_column :users, :network_name, :string
  end
end

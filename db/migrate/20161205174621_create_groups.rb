class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :rse_group_id
      t.string :rse_network_id
      t.string :network_name
      t.string :full_name
      t.string :description
      t.string :web_url
      t.string :mugshot_url

      t.timestamps
    end
  end
end

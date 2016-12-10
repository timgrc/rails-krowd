class CreateTechnipUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :technip_users do |t|
      t.integer :rse_id
      t.string :email
      t.string :job_title
      t.string :location
      t.string :expertise
      t.string :first_name
      t.string :last_name
      t.string :name
      t.string :mugshot_url_template
      t.string :timezone
      t.string :department
      t.string :contact
      t.string :network_name

      t.timestamps
    end
  end
end

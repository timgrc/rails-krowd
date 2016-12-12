class CreateBotUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :bot_users do |t|
      t.integer :latest_replied_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

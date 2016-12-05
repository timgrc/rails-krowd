class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :rse_post_id
      t.string :rse_created_at
      t.string :message_type
      t.string :web_url
      t.string :title
      t.string :plain
      t.string :rich
      t.string :liked_by
      t.string :disruption
      t.string :kind
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end

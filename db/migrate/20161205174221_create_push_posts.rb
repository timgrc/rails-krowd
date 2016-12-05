class CreatePushPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :push_posts do |t|
      t.string :title
      t.string :body
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

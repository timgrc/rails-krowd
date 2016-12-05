class CreateIncentiveTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :incentive_templates do |t|
      t.string :title
      t.string :body
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

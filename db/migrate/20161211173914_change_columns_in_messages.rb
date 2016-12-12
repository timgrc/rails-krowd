class ChangeColumnsInMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :post_id
    add_reference :messages, :thread, foreign_key: true
  end
end

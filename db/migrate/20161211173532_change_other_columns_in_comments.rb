class ChangeOtherColumnsInComments < ActiveRecord::Migration[5.0]
  def change
    remove_reference :comments, :post
    add_reference :comments, :thread, foreign_key: true

    rename_table :comments, :messages
  end
end

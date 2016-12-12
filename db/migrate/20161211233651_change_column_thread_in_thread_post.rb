class ChangeColumnThreadInThreadPost < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :thread_id
    add_reference :messages, :thread_post, foreign_key: true
  end
end

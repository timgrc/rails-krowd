class RemoveTechnipMessages < ActiveRecord::Migration[5.0]
  def change
    drop_table :technip_messages
  end
end

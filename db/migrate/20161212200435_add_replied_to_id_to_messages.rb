class AddRepliedToIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :replied_to_id, :integer
  end
end

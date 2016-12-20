class RemoveRseCreatedAtFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :rse_created_at, :string
  end
end

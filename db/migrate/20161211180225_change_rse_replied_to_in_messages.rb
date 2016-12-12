class ChangeRseRepliedToInMessages < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :rse_replied_to, :rse_replied_to_id
  end
end

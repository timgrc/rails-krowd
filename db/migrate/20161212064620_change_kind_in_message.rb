class ChangeKindInMessage < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :kind, :idea_kint_kext_social
  end
end

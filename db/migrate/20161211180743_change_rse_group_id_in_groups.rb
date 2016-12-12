class ChangeRseGroupIdInGroups < ActiveRecord::Migration[5.0]
  def change
    rename_column :groups, :rse_group_id, :rse_id
    remove_column :incentive_templates, :title
  end
end

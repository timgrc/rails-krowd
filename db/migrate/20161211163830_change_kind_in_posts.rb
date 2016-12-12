class ChangeKindInPosts < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :disruption, :innvovation_disruption
    rename_column :posts, :kind, :business_technology
  end
end

class ChangeTypoInnovationDisruption < ActiveRecord::Migration[5.0]
  def change
    rename_column :thread_posts, :innvovation_disruption, :innovation_disruption
  end
end

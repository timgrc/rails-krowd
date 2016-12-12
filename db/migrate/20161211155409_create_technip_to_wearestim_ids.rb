class CreateTechnipToWearestimIds < ActiveRecord::Migration[5.0]
  def change
    create_table :technip_to_wearestim_ids do |t|
      t.integer :technip_message_id
      t.integer :wearestim_message_id

      t.timestamps
    end
  end
end

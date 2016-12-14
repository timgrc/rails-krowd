class DeleteColumnUserInThread < ActiveRecord::Migration[5.0]
  def change
    remove_column :thread_posts, :user_id
  end
end

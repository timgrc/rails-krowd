class ChangeLastestReplyIdInThreads < ActiveRecord::Migration[5.0]
  def change
    rename_column :threads, :lastest_reply_id, :latest_reply_id
  end
end

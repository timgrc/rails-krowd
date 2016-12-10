class ChangeMugshotUrlTemplateToMugshotUrlInTechnipUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :technip_users, :mugshot_url_template, :mugshot_url
  end
end

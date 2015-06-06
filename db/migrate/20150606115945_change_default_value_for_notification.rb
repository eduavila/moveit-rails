class ChangeDefaultValueForNotification < ActiveRecord::Migration
  def change
  	change_column :user_interactions, :notification_read, :boolean, default: false
  end
end

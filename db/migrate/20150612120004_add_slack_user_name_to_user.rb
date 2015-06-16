class AddSlackUserNameToUser < ActiveRecord::Migration
  def change
  	add_column :users, :slack_user_name, :string
  end
end

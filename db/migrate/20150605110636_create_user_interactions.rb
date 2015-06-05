class CreateUserInteractions < ActiveRecord::Migration
  def change
    create_table :user_interactions do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :interaction_type
      t.boolean :notification_read

      t.timestamps null: false
    end

    add_index :user_interactions, :from_user_id
    add_index :user_interactions, :to_user_id
    add_index :user_interactions, :interaction_type
  end
end

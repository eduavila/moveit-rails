class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :subject_id
      t.string :subject_type
      t.integer :user_id
      t.integer :target_user_id

      t.timestamps null: false
    end
    
    add_index :activities, :user_id
    add_index :activities, :target_user_id
    add_index :activities, :subject_type
  end
end

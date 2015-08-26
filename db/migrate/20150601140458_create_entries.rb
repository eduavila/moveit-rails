class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.datetime :date, null: false
      t.integer :duration, null: false
      t.integer :user_id, null: false
      t.integer :amount_contributed, default: 0

      t.timestamps null: false
    end
    add_index :entries, :user_id
  end
end

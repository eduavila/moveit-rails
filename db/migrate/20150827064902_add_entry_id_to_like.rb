class AddEntryIdToLike < ActiveRecord::Migration
  def change
    add_column :user_interactions, :entry_id, :integer
    add_index :user_interactions, :entry_id
  end
end

class AddWorkoutImageUrlToEntry < ActiveRecord::Migration
  def change
  	add_column :entries, :workout_image_url, :string
  end
end

class AddForeignkeyConcert < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :event_id, :integer
  	add_foreign_key :concerts, :events
  end
end

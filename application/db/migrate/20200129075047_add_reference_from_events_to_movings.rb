class AddReferenceFromEventsToMovings < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :movings, :events
  end
end

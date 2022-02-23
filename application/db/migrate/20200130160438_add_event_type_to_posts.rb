class AddEventTypeToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :event_type, :string
  end
end

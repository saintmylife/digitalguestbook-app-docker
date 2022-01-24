class AddEventNameToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :event_name, :string
    
  end
end

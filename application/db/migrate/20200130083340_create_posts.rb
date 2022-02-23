class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :guest_id
      t.integer :event_id
      
      t.timestamps
    end
  end

end

class AddRealPersonToGuests < ActiveRecord::Migration[5.1]
    def change
      add_column :guests, :real_person, :integer, default: 0
    end
end
  
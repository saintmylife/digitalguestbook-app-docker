class AddNewFieldToConcert < ActiveRecord::Migration[5.1]
  def change
    add_column :concerts, :ticket, :boolean
    add_column :concerts, :time_of_get_ticket, :time
  end
end

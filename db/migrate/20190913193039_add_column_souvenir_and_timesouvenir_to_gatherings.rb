class AddColumnSouvenirAndTimesouvenirToGatherings < ActiveRecord::Migration[5.1]
  def change
    add_column :gatherings, :souvenir, :boolean
    add_column :gatherings, :time_of_get_souvenir, 'timestamp with time zone' 
  end
end

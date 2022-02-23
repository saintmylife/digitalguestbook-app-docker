class AddWinnerColumnToGathering < ActiveRecord::Migration[5.1]
  def change
    add_column :gatherings, :winner, :boolean, default: :false
    add_column :absensis, :winner, :boolean, default: :false
  end
end

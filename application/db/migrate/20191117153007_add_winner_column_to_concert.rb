class AddWinnerColumnToConcert < ActiveRecord::Migration[5.1]
  def change
    add_column :concerts, :winner, :boolean, default: :false
  end
end

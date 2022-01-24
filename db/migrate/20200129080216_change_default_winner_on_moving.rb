class ChangeDefaultWinnerOnMoving < ActiveRecord::Migration[5.1]
  def change
    change_column_default :movings, :winner, false
  end
end

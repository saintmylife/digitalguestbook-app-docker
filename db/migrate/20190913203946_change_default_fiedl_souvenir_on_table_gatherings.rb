class ChangeDefaultFiedlSouvenirOnTableGatherings < ActiveRecord::Migration[5.1]
  def change
    change_column_default :gatherings, :souvenir, false
  end
end

class ChangeDefaultFiedlPresenceOnTableConcerts < ActiveRecord::Migration[5.1]
  def change
        change_column_default :concerts, :presence, false
  end
end

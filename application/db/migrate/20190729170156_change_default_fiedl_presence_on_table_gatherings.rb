class ChangeDefaultFiedlPresenceOnTableGatherings < ActiveRecord::Migration[5.1]
  def change
        change_column_default :gatherings, :presence, false
  end
end

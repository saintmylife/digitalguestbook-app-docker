class RenameColumnNumberInEventToTargetOfGuest < ActiveRecord::Migration[5.1]
  def change
  	rename_column :events, :number, :target_of_guest
  end
end

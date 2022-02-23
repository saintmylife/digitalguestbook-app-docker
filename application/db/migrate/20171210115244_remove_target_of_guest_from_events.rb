class RemoveTargetOfGuestFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :target_of_guest, :integer
  end
end

class AddCountPersonToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :count_person, :boolean, default: :false
  end
end

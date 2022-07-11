class AddColumnCustomToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :custom_one, :boolean
    add_column :settings, :custom_two, :boolean
    add_column :settings, :custom_three, :boolean
    add_column :settings, :custom_four, :boolean
    add_column :settings, :custom_five, :boolean
  end
end

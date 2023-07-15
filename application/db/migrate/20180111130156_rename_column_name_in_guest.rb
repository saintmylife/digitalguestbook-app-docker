class RenameColumnNameInGuest < ActiveRecord::Migration[5.1]
  def change
    rename_column :guests, :custom_one, :custom_one_text
    rename_column :guests, :custom_two, :custom_two_text
    rename_column :guests, :custom_three, :custom_three_text
    rename_column :guests, :custom_four, :custom_four_text
    rename_column :guests, :custom_five, :custom_five_text
  end
end

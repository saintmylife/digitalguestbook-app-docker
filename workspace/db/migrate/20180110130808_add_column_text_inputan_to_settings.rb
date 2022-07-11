class AddColumnTextInputanToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :custom_one_text, :text
    add_column :settings, :custom_two_text, :text
    add_column :settings, :custom_three_text, :text
    add_column :settings, :custom_four_text, :text
    add_column :settings, :custom_five_text, :text
  end
end

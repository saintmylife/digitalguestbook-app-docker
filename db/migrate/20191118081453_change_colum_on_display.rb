class ChangeColumOnDisplay < ActiveRecord::Migration[5.1]
  def change
      remove_column :displays, :souvenir
      add_column :displays, :kota, :boolean, default: :true
  end
end

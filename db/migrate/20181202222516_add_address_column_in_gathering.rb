class AddAddressColumnInGathering < ActiveRecord::Migration[5.1]
  def change
  	add_column :gatherings,:address, :string
  end
end

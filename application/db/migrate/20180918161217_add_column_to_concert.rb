class AddColumnToConcert < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :name, :string
  	add_column :concerts, :address, :string
  	add_column :concerts, :category, :string
  end
end

class AddColumConcert < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :kwitansi, :date
  	add_column :concerts, :name_1, :string
  end
end

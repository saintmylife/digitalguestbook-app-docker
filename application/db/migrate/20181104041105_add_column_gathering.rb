class AddColumnGathering < ActiveRecord::Migration[5.1]
  def change
  	add_column :gatherings, :instansi, :string
  	add_column :gatherings, :category, :string
  	add_column :gatherings, :kelas, :string
  end
end

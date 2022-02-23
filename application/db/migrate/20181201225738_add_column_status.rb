class AddColumnStatus < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :status, :string
  end
end

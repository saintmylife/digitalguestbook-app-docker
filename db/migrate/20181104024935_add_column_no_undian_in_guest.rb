class AddColumnNoUndianInGuest < ActiveRecord::Migration[5.1]
  def change
  	add_column :guests, :no_undian, :string
  end
end

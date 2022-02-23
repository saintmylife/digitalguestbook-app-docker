class AddClassUserToConcert < ActiveRecord::Migration[5.1]
  def change
  	add_column :concerts, :class_user, :string
  end
end

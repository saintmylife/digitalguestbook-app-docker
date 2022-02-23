class AddColumnToMovings < ActiveRecord::Migration[5.1]
  def change
    add_column :movings, :presence2, :boolean, default: :false
    add_column :movings, :presence3, :boolean, default: :false
    add_column :movings, :presence4, :boolean, default: :false
    add_column :movings, :presence5, :boolean, default: :false
    add_column :movings, :presence6, :boolean, default: :false
    add_column :movings, :presence7, :boolean, default: :false
    add_column :movings, :presence8, :boolean, default: :false
    add_column :movings, :presence9, :boolean, default: :false
    add_column :movings, :presence10, :boolean, default: :false

    add_column :movings, :souvenir2, :boolean, default: :false
    add_column :movings, :souvenir3, :boolean, default: :false
    add_column :movings, :souvenir4, :boolean, default: :false
    add_column :movings, :souvenir5, :boolean, default: :false
    add_column :movings, :souvenir6, :boolean, default: :false
    add_column :movings, :souvenir7, :boolean, default: :false
    add_column :movings, :souvenir8, :boolean, default: :false
    add_column :movings, :souvenir9, :boolean, default: :false
    add_column :movings, :souvenir10, :boolean, default: :false
  end
end

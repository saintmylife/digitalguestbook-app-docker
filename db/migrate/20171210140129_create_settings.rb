class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.boolean :no_undian, default: :false
      t.boolean :nama_meja, default: :false
      t.boolean :nama_undangan, default: :false

      t.timestamps
    end
  end
end

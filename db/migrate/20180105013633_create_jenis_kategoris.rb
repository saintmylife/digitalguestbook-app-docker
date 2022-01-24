class CreateJenisKategoris < ActiveRecord::Migration[5.1]
  def change
    create_table :jenis_kategoris do |t|
      t.string :name
      
      t.timestamps
    end
  end
end

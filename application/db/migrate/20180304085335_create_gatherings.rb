class CreateGatherings < ActiveRecord::Migration[5.1]
  def change
    create_table :gatherings do |t|
      t.string :guest_id
      t.string :unit_kerja
      t.string :nip
      t.string :nama_peserta
      t.string :status_pegawai

      t.timestamps
    end
  end
end

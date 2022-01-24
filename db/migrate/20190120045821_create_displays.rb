class CreateDisplays < ActiveRecord::Migration[5.1]
  def change
    create_table :displays do |t|
      	 t.boolean :nama, default:true
      	 t.boolean :alamat, default:true
  	     t.boolean :nomor_ponsel, default:true
	       t.boolean :kategori, default:true
      	 t.boolean :status, default:true
      	 t.boolean :nama_meja, default:true
 		     t.boolean :guest_id, default:true
      	 t.boolean :souvenir, default:true
      	 t.boolean :jumlah_souvenir, default:true
      	 t.boolean :nama_angpao, default:true
      	 t.boolean :no_undian, default:true
      	 t.boolean :jumlah_undangan, default:true
      	 t.boolean :jabatan, default:true

      	 t.integer :setting_id
      	 t.timestamps
    end
  end
end

class CreateSettingUndians < ActiveRecord::Migration[5.1]
  def change
    create_table :settingundians do |t|
        t.string :nama_undian
        t.boolean :status, default: :false

        t.timestamps
    end
  end
end

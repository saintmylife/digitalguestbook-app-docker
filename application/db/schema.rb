# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220420234535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absensis", force: :cascade do |t|
    t.string "guest_id"
    t.string "nama"
    t.string "alamat"
    t.string "kategori"
    t.boolean "presence", default: false
    t.time "time_of_entry"
    t.boolean "souvenir", default: false
    t.time "time_of_get_souvenir"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.boolean "winner", default: false
    t.string "instansi"
    t.string "jabatan"
    t.string "unit_kerja"
    t.string "other1"
    t.string "other2"
    t.string "other3"
  end

  create_table "concerts", force: :cascade do |t|
    t.string "guest_id"
    t.boolean "presence", default: false
    t.time "time_of_entry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.boolean "ticket", default: false
    t.time "time_of_get_ticket"
    t.string "nama"
    t.string "alamat"
    t.string "kategori"
    t.string "class_user"
    t.string "no_ktp"
    t.string "email"
    t.string "no_ponsel"
    t.string "jenis_tiket"
    t.integer "jumlah_tiket"
    t.date "kwitansi"
    t.string "name_1"
    t.string "status"
    t.boolean "winner", default: false
  end

  create_table "displays", force: :cascade do |t|
    t.boolean "nama", default: true
    t.boolean "alamat", default: true
    t.boolean "nomor_ponsel", default: true
    t.boolean "kategori", default: true
    t.boolean "status", default: true
    t.boolean "nama_meja", default: true
    t.boolean "guest_id", default: true
    t.boolean "jumlah_souvenir", default: true
    t.boolean "nama_angpao", default: true
    t.boolean "no_undian", default: true
    t.boolean "jumlah_undangan", default: true
    t.boolean "jabatan", default: true
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "kota", default: true
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "event_owner"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_of_event_id"
    t.string "code"
  end

  create_table "gatherings", force: :cascade do |t|
    t.string "guest_id"
    t.string "unit_kerja"
    t.string "nip"
    t.string "nama_peserta"
    t.string "status_pegawai"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.boolean "presence", default: false
    t.time "time_of_entry"
    t.string "instansi"
    t.string "category"
    t.string "kelas"
    t.string "jabatan"
    t.string "email"
    t.string "no_ponsel"
    t.string "jenis_kelamin"
    t.string "address"
    t.integer "jumlah_orang"
    t.boolean "souvenir", default: false
    t.datetime "time_of_get_souvenir"
    t.boolean "winner", default: false
  end

  create_table "guest_temporaries", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.boolean "presence"
    t.time "time_of_entry"
    t.string "city"
    t.string "category"
    t.string "type_of_guest"
    t.integer "no_undian"
    t.string "nama_meja"
    t.string "guest_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_of_present"
  end

  create_table "guests", force: :cascade do |t|
    t.string "nama"
    t.string "alamat"
    t.string "nomor_ponsel"
    t.boolean "presence", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kota"
    t.string "kategori"
    t.string "status"
    t.string "nama_meja"
    t.string "guest_id"
    t.integer "event_id"
    t.boolean "souvenir", default: false
    t.string "jumlah_souvenir", default: "1"
    t.text "custom_one_text"
    t.text "custom_two_text"
    t.text "custom_three_text"
    t.text "custom_four_text"
    t.text "custom_five_text"
    t.datetime "time_of_entry"
    t.text "souvenir_text"
    t.datetime "time_of_get_souvenir"
    t.text "nama_angpao"
    t.string "no_undian"
    t.integer "jumlah_undangan"
    t.string "jabatan"
    t.boolean "winner", default: false
    t.integer "real_person", default: 0
  end

  create_table "jenis_kategoris", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logmovings", force: :cascade do |t|
    t.string "guest_id"
    t.integer "event_id"
    t.string "nama"
    t.string "alamat"
    t.string "kategori"
    t.string "instansi"
    t.string "jabatan"
    t.string "unit_kerja"
    t.string "other1"
    t.string "other2"
    t.string "other3"
    t.string "keterangan"
    t.string "kelas"
    t.time "waktu"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "guest_id"
    t.integer "event_id"
    t.time "waktu"
    t.string "keterangan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nama"
    t.string "alamat"
    t.string "kategori"
    t.string "instansi"
    t.string "jabatan"
    t.string "unit_kerja"
    t.string "other1"
    t.string "other2"
    t.string "other3"
    t.boolean "status", default: true
  end

  create_table "movings", force: :cascade do |t|
    t.string "guest_id"
    t.integer "event_id"
    t.string "nama"
    t.string "alamat"
    t.string "kategori"
    t.string "instansi"
    t.string "jabatan"
    t.string "unit_kerja"
    t.string "other1"
    t.string "other2"
    t.string "other3"
    t.boolean "presence", default: false
    t.boolean "souvenir", default: false
    t.boolean "winner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "presence2", default: false
    t.boolean "presence3", default: false
    t.boolean "presence4", default: false
    t.boolean "presence5", default: false
    t.boolean "presence6", default: false
    t.boolean "presence7", default: false
    t.boolean "presence8", default: false
    t.boolean "presence9", default: false
    t.boolean "presence10", default: false
    t.boolean "souvenir2", default: false
    t.boolean "souvenir3", default: false
    t.boolean "souvenir4", default: false
    t.boolean "souvenir5", default: false
    t.boolean "souvenir6", default: false
    t.boolean "souvenir7", default: false
    t.boolean "souvenir8", default: false
    t.boolean "souvenir9", default: false
    t.boolean "souvenir10", default: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "guest_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "event_name"
    t.string "event_type"
  end

  create_table "settings", force: :cascade do |t|
    t.boolean "no_undian", default: false
    t.boolean "nama_meja", default: false
    t.boolean "nama_undangan", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "custom_one"
    t.boolean "custom_two"
    t.boolean "custom_three"
    t.boolean "custom_four"
    t.boolean "custom_five"
    t.text "custom_one_text"
    t.text "custom_two_text"
    t.text "custom_three_text"
    t.text "custom_four_text"
    t.text "custom_five_text"
    t.boolean "nama_angpao"
    t.boolean "jumlah_souvenir"
    t.boolean "jumlah_undangan", default: false
    t.boolean "count_person", default: false
  end

  create_table "settingundians", force: :cascade do |t|
    t.string "nama_undian"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "type_of_events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", default: "", null: false
    t.string "role", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roles_mask"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "absensis", "events"
  add_foreign_key "concerts", "events"
  add_foreign_key "events", "type_of_events"
  add_foreign_key "gatherings", "events"
  add_foreign_key "guests", "events"
  add_foreign_key "movings", "events"
end

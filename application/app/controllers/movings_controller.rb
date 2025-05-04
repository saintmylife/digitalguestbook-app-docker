class MovingsController < ApplicationController
  include PresencesHelper, ApplicationHelper, ActionView::Helpers::NumberHelper
  helper_method :sort_column, :sort_direction

  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def index
    render_index_page("CHECK IN Registrasi", "Class01")
  end

  # kelas controller
  def class2
    render_index_page("CHECK IN Goodie Bag", "Class02")
  end

  def class3
    render_index_page("CHECK IN Ruang Seminar", "Class03")
  end

  def class4
    render_index_page("CHECK IN Makan Siang", "Class04")
  end

  def class5
    render_index_page("CHECK IN CLASS V", "Class05")
  end

  def class6
    render_index_page("CHECK IN CLASS VI", "Class06")
  end

  def class7
    render_index_page("CHECK IN CLASS VII", "Class07")
  end

  def class8
    render_index_page("CHECK IN CLASS VIII", "Class08")
  end

  def class9
    render_index_page("CHECK IN CLASS IX", "Class09")
  end

  def class10
    render_index_page("CHECK IN CLASS X", "Class10")
  end

  # END CLASS CONTROLLER
  def show
    @moving   = Moving.find(params[:id])
    @detail   = @moving.guest_id
    @searchid = Logmoving.where(guest_id: @detail).all
    respond_to do |f|
      f.js
    end
  end

  def master
    if params[:search].present?
      @page    = params[:page]
      @movings = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .search(params[:search], params[:checkbox])
                       .page(@page).per(50)
    else
      @page    = params[:page]
      @movings = Moving.joins(event: :type_of_event).where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .order(sort_column + " " + sort_direction)
                       .page(@page).per(50)
    end
    if params[:reset_button]
      redirect_to master_movings_path
    end
  end

  def masterdata
    if params[:name_search].present?
      @movings = Moving.joins(event: :type_of_event)
                       .search(params[:name_search])
    else
      @page = params[:page]

      @movings = Moving.joins(event: :type_of_event).where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .order(nama: :asc)
                       .page(@page).per(50)

      respond_to do |f|
        f.js
        f.html
      end
    end
    respond_to do |f|
      f.js
      f.html
    end
  end

  # GET /guests/import
  def import
    is_success = Moving.import(params[:file], params[:moving][:event_id])
    notice = "Data imported successfully!"
    unless is_success
      notice = "Gagal Mengimport Data"
    end

    redirect_to masterdata_movings_path, notice: notice
  end

  def pengaturan
  end

  def reset
    event_id = Event.find_by(status: true).id
    absensi  = Absensi.where(event_id: event_id)
    Absensi.update_all(:presence => false, :time_of_entry => nil)
    redirect_to absensis_path, notice: "Absensi reset"
  end

  def print
    render layout: false
  end

  def template_qr
    render layout: false
  end

  def template_qr_master
    render layout: false
  end

  def print_qr
    @qrcode = params[:guest_qr]

    respond_to do |format|
      format.js { render 'movings/print_qr' }
    end
  end

  def print_qr_master
    if params[:guest_id].present?
      find_guest2 = Moving.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'movings/print_qr_master' }
    end
  end

  def update_presence
    @settingan = Setting.last
    @presence  = nil

    selected_column = get_presence_field(params[:classname], true)

    # If no valid column, return render immediately
    if selected_column.nil?
      respond_to do |format|
        format.js { render "movings/index" }
      end
      return
    end

    # Find the event with the correct type and status
    event = Event.joins(:type_of_event)
                 .find_by(type_of_events: { name: 'Moving' }, status: true)

    ActiveRecord::Base.transaction do
      @find_guest = Moving.find_by(event_id: event.id, guest_id: params[:guest_code])

      # If the guest is not found, render 'movings/index' and exit early
      if @find_guest.nil? || !@find_guest.attributes.key?(selected_column)
        respond_to do |format|
          format.js { render "movings/index" }
        end
        return
      end

      if @find_guest.send(selected_column).present?
        @presence = false
        respond_to do |format|
          format.js { render "movings/index" }
        end
        return
      end

      # Set the selected column to the current time
      @find_guest.send("#{selected_column}=", Time.now())

      unless @find_guest.save
        raise ActiveRecord::Rollback
      end

      @presence = true
    end

    respond_to do |format|
      format.js { render "movings/index" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.js { render "movings/index" }
    end
  end

  def update_presence_deprecated
    @find_guest = Moving.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Moving%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:guest_code])
    # start-debug-class
    case params[:classname]
    when "Class01"
      @class_check = @find_guest.select("presence as cek_masuk, souvenir as cek_keluar").first
    when "Class02"
      @class_check = @find_guest.select("presence2 as cek_masuk, souvenir2 as cek_keluar").first
    when "Class03"
      @class_check = @find_guest.select("presence3 as cek_masuk, souvenir3 as cek_keluar").first
    when "Class04"
      @class_check = @find_guest.select("presence4 as cek_masuk, souvenir4 as cek_keluar").first
    when "Class05"
      @class_check = @find_guest.select("presence5 as cek_masuk, souvenir5 as cek_keluar").first
    when "Class06"
      @class_check = @find_guest.select("presence6 as cek_masuk, souvenir6 as cek_keluar").first
    when "Class07"
      @class_check = @find_guest.select("presence7 as cek_masuk, souvenir7 as cek_keluar").first
    when "Class08"
      @class_check = @find_guest.select("presence8 as cek_masuk, souvenir8 as cek_keluar").first
    when "Class09"
      @class_check = @find_guest.select("presence9 as cek_masuk, souvenir9 as cek_keluar").first
    else
      "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    # end-debug-class
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      setting    = Setting.where(id: @find_guest.first.event_id)
      @settingan = Setting.last
      @print     = {}
      ScanWorkerMovingClass.perform_async(params[:guest_code], params[:classname])
      # Masuk ke log
      @baru = Logmoving.create(guest_id: params[:guest_code], event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Masuk", kelas: params[:classname])
      # end masuk ke log
      @presence = 'Sukses'
      # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      # Masuk ke log
      @baru = Logmoving.create(guest_id: params[:guest_code], event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Masuk", kelas: params[:classname])
      # end masuk ke log
      # cek terakhirmasuk
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Masuk")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirmasuk
      # cek terakhirkeluar
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Keluar")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirkeluar
      @presence = 'Setelah'
      # Melakukan Reset CheckOut
      @resetcheckout = Moving.where(guest_id: @find_guest.first.guest_id)
                             .where(event_id: @find_guest.first.event_id)
      case params[:classname]
      when "Class1"
        @resetcheckoutdone = @resetcheckout.update(:souvenir => false)
      when "Class2"
        @resetcheckoutdone = @resetcheckout.update(:souvenir2 => false)
      when "Class3"
        @resetcheckoutdone = @resetcheckout.update(:souvenir3 => false)
      when "Class4"
        @resetcheckoutdone = @resetcheckout.update(:souvenir4 => false)
      when "Class5"
        @resetcheckoutdone = @resetcheckout.update(:souvenir5 => false)
      when "Class6"
        @resetcheckoutdone = @resetcheckout.update(:souvenir6 => false)
      when "Class7"
        @resetcheckoutdone = @resetcheckout.update(:souvenir7 => false)
      when "Class8"
        @resetcheckoutdone = @resetcheckout.update(:souvenir8 => false)
      when "Class9"
        @resetcheckoutdone = @resetcheckout.update(:souvenir9 => false)
      when "Class10"
        @resetcheckoutdone = @resetcheckout.update(:souvenir10 => false)
      end
      # Sudah Masuk, Belum Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != TRUE
      @presence = 'Belum'
      # Cek terakhirmasuk
      @cekterakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                              .where(keterangan: "Masuk")
                              .where(kelas: params[:classname])
                              .last
      # end cek terakhir
      # Non Ident
    else
      @presence = 'Gagal'
    end
    respond_to do |format|
      format.js { render 'movings/index' }
    end
  end

  # for mobile presence
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_presence_mobile
    scan_guest(params[:guest_code], params[:classname], true)
  end

  def update_souvenir_mobile
    scan_guest(params[:souvenir], params[:classname], false)
  end

  def update_presence_mobile_deprecated
    @find_guest = Moving.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Moving%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:guest_code])
    @eventid    = Event.joins(:type_of_event)
                       .where(status: true)
                       .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    # start-debug-class
    case params[:classname]
    when "Class01"
      @class_check = @find_guest.select("presence as cek_masuk, souvenir as cek_keluar").first
    when "Class02"
      @class_check = @find_guest.select("presence2 as cek_masuk, souvenir2 as cek_keluar").first
    when "Class03"
      @class_check = @find_guest.select("presence3 as cek_masuk, souvenir3 as cek_keluar").first
    when "Class04"
      @class_check = @find_guest.select("presence4 as cek_masuk, souvenir4 as cek_keluar").first
    when "Class05"
      @class_check = @find_guest.select("presence5 as cek_masuk, souvenir5 as cek_keluar").first
    when "Class06"
      @class_check = @find_guest.select("presence6 as cek_masuk, souvenir6 as cek_keluar").first
    when "Class07"
      @class_check = @find_guest.select("presence7 as cek_masuk, souvenir7 as cek_keluar").first
    when "Class08"
      @class_check = @find_guest.select("presence8 as cek_masuk, souvenir8 as cek_keluar").first
    when "Class09"
      @class_check = @find_guest.select("presence9 as cek_masuk, souvenir9 as cek_keluar").first
    else
      "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    # end-debug-class
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      setting    = Setting.where(id: @find_guest.first.event_id)
      @settingan = Setting.last
      @print     = {}
      ScanWorkerMovingClass.perform_async(params[:guest_code], params[:classname])
      # Masuk ke log
      @baru = Logmoving.create(guest_id: params[:guest_code], event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Masuk", kelas: params[:classname])
      # end masuk ke log
      # JSON ke mobileapps
      respond_to do |format|
        format.json { render json: {
          message: "Success", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.jabatan,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    true, # ini buat logo
        }, status:                 200
        }
      end
      # end json ke mobileapps
      # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      # Masuk ke log
      @baru = Logmoving.create(guest_id: params[:guest_code], event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Masuk", kelas: params[:classname])
      # end masuk ke log
      # cek terakhirmasuk
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Masuk")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirmasuk
      # cek terakhirkeluar
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Keluar")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirkeluar
      # json ke mobile apps
      # end json ke mobile apps
      respond_to do |format|
        format.json { render json: {
          message: "Silahkan Check In", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.alamat,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      end
      # Melakukan Reset CheckOut
      @resetcheckout = Moving.where(guest_id: @find_guest.first.guest_id)
                             .where(event_id: @find_guest.first.event_id)
      case params[:classname]
      when "Class1"
        @resetcheckoutdone = @resetcheckout.update(:souvenir => false)
      when "Class2"
        @resetcheckoutdone = @resetcheckout.update(:souvenir2 => false)
      when "Class3"
        @resetcheckoutdone = @resetcheckout.update(:souvenir3 => false)
      when "Class4"
        @resetcheckoutdone = @resetcheckout.update(:souvenir4 => false)
      when "Class5"
        @resetcheckoutdone = @resetcheckout.update(:souvenir5 => false)
      when "Class6"
        @resetcheckoutdone = @resetcheckout.update(:souvenir6 => false)
      when "Class7"
        @resetcheckoutdone = @resetcheckout.update(:souvenir7 => false)
      when "Class8"
        @resetcheckoutdone = @resetcheckout.update(:souvenir8 => false)
      when "Class9"
        @resetcheckoutdone = @resetcheckout.update(:souvenir9 => false)
      when "Class10"
        @resetcheckoutdone = @resetcheckout.update(:souvenir10 => false)
      end
      # Sudah Masuk, Belum Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != TRUE
      # json ke mobile apps
      respond_to do |format|
        format.json { render json: {
          message: "Belum Checkout", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.alamat,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      end
      # end json ke mobile apps
      # Cek terakhirmasuk
      @cekterakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                              .where(keterangan: "Masuk")
                              .where(kelas: params[:classname])
                              .last
      # end cek terakhir
      # Non Ident
    else
      respond_to do |format|
        format.json { render json: {
          message: "Tolak", # data yang mau ditampilkan di app
          guest_id: "",
          nama:     "",
          alamat:   "",
          other1:   "",
          other2:   "",
          other3:   "",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      end
    end
  end

  def souvenirmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_souvenir_mobile_deprecated
    @find_guest = Moving.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Moving%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:souvenir])
    # start-debug-class
    case params[:classname]
    when "Class01"
      @class_check = @find_guest.select("presence as cek_masuk, souvenir as cek_keluar").first
    when "Class02"
      @class_check = @find_guest.select("presence2 as cek_masuk, souvenir2 as cek_keluar").first
    when "Class03"
      @class_check = @find_guest.select("presence3 as cek_masuk, souvenir3 as cek_keluar").first
    when "Class04"
      @class_check = @find_guest.select("presence4 as cek_masuk, souvenir4 as cek_keluar").first
    when "Class05"
      @class_check = @find_guest.select("presence5 as cek_masuk, souvenir5 as cek_keluar").first
    when "Class06"
      @class_check = @find_guest.select("presence6 as cek_masuk, souvenir6 as cek_keluar").first
    when "Class07"
      @class_check = @find_guest.select("presence7 as cek_masuk, souvenir7 as cek_keluar").first
    when "Class08"
      @class_check = @find_guest.select("presence8 as cek_masuk, souvenir8 as cek_keluar").first
    when "Class09"
      @class_check = @find_guest.select("presence9 as cek_masuk, souvenir9 as cek_keluar").first
    when "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    # Sudah Masuk, Belum Keluar (Sudah CheckIN)
    if @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != TRUE
      SouvenirWorkerMovingClass.perform_async(params[:souvenir], params[:classname])
      # masuk ke logmoving
      @baru = Logmoving.create(guest_id: params[:souvenir], event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Keluar", kelas: params[:classname])
      # end masuk ke logmoving
      # cek terakhirkeluar
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Keluar")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirkeluar
      # cek terakhirmasuk
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Masuk")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirmasuk
      @souvenir = 'Sukses'
      # Belum Masuk, Belum Keluar (Belum CheckIN)
    elsif @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      @souvenir = 'Belum'
      # Sudah Masuk, Sudah Keluar (Sudah Semua, Mohon Check Masuk ke pintu CheckIN)
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      @souvenir = 'Sudah'
      # cek terakhirmasuk
      @cekterakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                              .where(keterangan: "Keluar")
                              .where(kelas: params[:classname])
                              .last
      # end terakhirmasuk
      # Non Ident
    else
      @souvenir = 'Gagal'
    end
    respond_to do |format|
      case @souvenir
      when 'Sukses'
        format.json { render json: {
          message: "Success", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.alamat,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      when 'Belum'
        format.json { render json: {
          message: "Belum", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.alamat,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      when 'Sudah'
        format.json { render json: {
          message: "Already", # data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama:     @find_guest.first.nama,
          alamat:   @find_guest.first.alamat,
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      else
        'Gagal'
        format.json { render json: {
          message: "Tolak", # data yang mau ditampilkan di app
          guest_id: "",
          nama:     "",
          alamat:   "",
          other1:   "other1",
          other2:   "other2",
          other3:   "other3",
          hasil:    false, # ini buat logo
        }, status:                 200
        }
      end
    end
  end

  # end for mobile

  def printulang
    render layout: 'presence'
  end

  def reprint
    @guest_code = params[:guest_code]
    respond_to do |format|
      format.js { render 'movings/reprint' }
    end
  end

  def create
    @moving = Moving.create(moving_params)
    if @moving.save
      redirect_to new_moving_path, notice: "Tambah Data Berhasil !!!"
    else
      redirect_to new_moving_path, alert: "Gagal Tambah Data, Mohon Cek Form"
    end
  end

  def new
    @moving     = Moving.new
    @checkaktif = TypeOfEvent.joins(:events)
                             .where("events.status": true)
                             .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    else
      redirect_to masterdata_movings_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def edit
    @moving = Moving.find(params[:id])
  end

  def update
    @moving = Moving.find(params[:id])
    if @moving.update(moving_params)
      redirect_to master_movings_path, notice: "Berhasil Edit"
    else
      redirect_to master_movings_path, alert: "Gagal Edit"
    end
  end

  def destroy
    @moving = Moving.find(params[:id])
    @moving.destroy
    @movinglog = Logmoving.where(guest_id: @moving.guest_id)
    @movinglog.delete_all
    redirect_to master_movings_path, notice: "Berhasil Hapus Data"
  end

  def souvenir
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  # CLASS SOUVENIR CONTROLLER
  def souvenir2
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir3
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir4
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir5
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir6
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir7
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir8
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir9
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  def souvenir10
    @settingwedd = Setting.first
    @checkaktif  = TypeOfEvent.joins(:events)
                              .where("events.status": true)
                              .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                      .where(status: true)
                      .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    end
  end

  # END CLASS CONTROLLER
  def update_souvenir
    @find_guest = Moving.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Moving%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:souvenir])
    @eventid    = Event.joins(:type_of_event)
                       .where(status: true)
                       .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    # start-debug-class
    case params[:classname]
    when "Class01"
      @class_check = @find_guest.select("presence as cek_masuk, souvenir as cek_keluar").first
    when "Class02"
      @class_check = @find_guest.select("presence2 as cek_masuk, souvenir2 as cek_keluar").first
    when "Class03"
      @class_check = @find_guest.select("presence3 as cek_masuk, souvenir3 as cek_keluar").first
    when "Class04"
      @class_check = @find_guest.select("presence4 as cek_masuk, souvenir4 as cek_keluar").first
    when "Class05"
      @class_check = @find_guest.select("presence5 as cek_masuk, souvenir5 as cek_keluar").first
    when "Class06"
      @class_check = @find_guest.select("presence6 as cek_masuk, souvenir6 as cek_keluar").first
    when "Class07"
      @class_check = @find_guest.select("presence7 as cek_masuk, souvenir7 as cek_keluar").first
    when "Class08"
      @class_check = @find_guest.select("presence8 as cek_masuk, souvenir8 as cek_keluar").first
    when "Class09"
      @class_check = @find_guest.select("presence9 as cek_masuk, souvenir9 as cek_keluar").first
    when "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    # Sudah Masuk, Belum Keluar (Sudah CheckIN)
    if @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != TRUE
      SouvenirWorkerMovingClass.perform_async(params[:souvenir], params[:classname])
      # masuk ke logmoving
      @baru = Logmoving.create(guest_id: params[:souvenir], event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(), keterangan: "Keluar", kelas: params[:classname])
      # end masuk ke logmoving
      # cek terakhirkeluar
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Keluar")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirkeluar
      # cek terakhirmasuk
      @terakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                           .where(keterangan: "Masuk")
                           .where(kelas: params[:classname])
                           .order(waktu: :desc)
                           .limit(5)
      # end terakhirmasuk
      @souvenir = 'Sukses'
      # Belum Masuk, Belum Keluar (Belum CheckIN)
    elsif @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      @souvenir = 'Belum'
      # Sudah Masuk, Sudah Keluar (Sudah Semua, Mohon Check Masuk ke pintu CheckIN)
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      @souvenir = 'Sudah'
      # cek terakhirmasuk
      @cekterakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                              .where(keterangan: "Keluar")
                              .where(kelas: params[:classname])
                              .last
      # end terakhirmasuk
      # Non Ident
    else
      @souvenir = 'Gagal'
    end
    respond_to do |format|
      format.js { render 'movings/index' }
    end
  end

  def print_qr_page
    render layout: 'presence'
  end

  def update_print_qr_page
  end

  def dashboard
    @event = Event.joins(:type_of_event)
                 .find_by(type_of_events: { name: 'Moving' }, status: true)
    guests_count_group = Moving.count_by_presence(@event.id, false)
    @guest_total = Moving.where(:event_id => @event.id).count
    @guest_total_added = Moving.where(:event_id => @event.id).where(kategori: 'TAMBAHAN').count

    @guest_count_map = guests_count_group.transform_values do |count|
      percentage = (count.to_f / @guest_total) * 100
      {
        "count"      => count,
        "percentage" => number_to_percentage(percentage, precision: 2, strip_insignificant_zeros: true)
      }
    end

    @guest_count_category = Moving.where(event_id: @event.id).group(:kategori).count
    @guest_count_category_map = Moving.count_by_presence_group_by_category(@event.id)

    render layout: 'dashboard'

    respond_to do |format|
      format.html
      format.js
    end
  end

  def clientview
    content            = {}
    @total_guest       = Absensi.joins(:event).where("events.status=true").count
    @guest_sudah_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=true").count
    @guest_belum_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=false").count
    @jumlah_souvenir   = Absensi.joins(:event).where("events.status=true").where("absensis.souvenir=true").count
    @jenis_kategori    = Absensi.joins(:event).where("events.status=true")
                                .select("
                        kategori,
                        COUNT(absensis.kategori) as JumlahKategori,
                        COUNT(absensis.id) filter (where presence = TRUE) as Hadir,
                        COUNT(absensis.id) filter (where presence = TRUE) as HadirDua,
                        COUNT(absensis.id) filter (where presence = FALSE) as TidakHadir
                      ")
                                .group("kategori")
                                .order(kategori: :asc)
  end

  def report
    @setting     = Setting.first
    @events      = TypeOfEvent.joins(:events).where(name: "Moving").select("events.name as name,events.id as id")
    @guests      = Logmoving.where(event_id: params[:event_id]).where(status: :true).order(guest_id: :asc)
    @guestsfalse = Moving.where(event_id: params[:event_id])
                         .where(presence: :false)
                         .where(presence2: :false)
                         .where(presence3: :false)
                         .where(presence4: :false)
                         .where(presence5: :false)
                         .where(presence6: :false)
                         .where(presence7: :false)
                         .where(presence8: :false)
                         .where(presence9: :false)
                         .where(presence10: :false)
                         .order(guest_id: :asc)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_absensi
    unless params[:event].nil?
      if params[:jenis_kategori].present?
        data_hadir       = Absensi.joins(:event)
                                  .where("events.name like '%#{params[:event][:event_id]}%'")
                                  .where(presence: true)
        data_tidak_hadir = Absensi.joins(:event)
                                  .where("events.name like '%#{params[:event][:event_id]}%'")
                                  .where('absensis.presence = false or absensis.presence = null')
        @report          = tentukan_jenis_report(params[:jenis_kategori], data_hadir, data_tidak_hadir, params[:presence_kategori])
      end

      @no = if params[:page].to_i == 1 || params[:page].blank?
              1
            else
              (params[:page].to_i * 100) - 100 + 1
            end

      respond_to do |format|
        format.js { render '/absensis/report_wedding' }
      end
    else
      @jenis_kategori = delete_duplicate_value(Absensi.select(:category))
    end
  end

  def export_excel
    @custom_header = Setting.all
    @exports       = Absensi.joins(:event).where("events.name like '%#{params[:event]}%'")
    respond_to do |format|
      format.xls
    end
  end

  def reset_presence_souvenir
    is_success = Moving.reset_by_id(params[:id])
    unless is_success
      # Send a JS response with an error toastr notification
      return render js: "toastr['error']('Data tidak ditemukan')"
    end

    render js: "toastr['info']('Success mereset');"
  end

  private

  def moving_params
    params.require(:moving).permit(:guest_id, :nama, :event_id, :kategori, :alamat, :instansi, :jabatan, :unit_kerja)
  end

  def sort_column
    params[:sort] || "nama"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def render_data_not_found
    render json: {
      message: "ID Tidak Terdaftar",
      guest_id: "",
      nama:     "ID Tidak Terdaftar",
      alamat:   "",
      other1:   "",
      other2:   "",
      other3:   "",
      hasil:    false,
    }, status:   200
  end

  def scan_guest(guest_code, class_name, is_checkin)
      # Find the event with the correct type and status
      event = Event.joins(:type_of_event)
                   .find_by(type_of_events: { name: 'Moving' }, status: true)
      # If event is not found, render data not found and exit the transaction
      return render_data_not_found if event.nil?

    ActiveRecord::Base.transaction do
      # Find the guest in the moving table
      guest = Moving.find_by(event_id: event.id, guest_id: guest_code)
      # If guest is not found, render data not found and exit the transaction
      return render_data_not_found if guest.nil?

      # Determine the selected column using the private method
      selected_column = get_presence_field(class_name, is_checkin)
      # If no valid column, return not found
      return render_data_not_found if selected_column.nil?

      # Ensure that the guest has the selected column
      unless guest.attributes.has_key?(selected_column)
        return render_data_not_found
      end

      # Prepare response data
      data = {
        "message"  => "Already",
        "guest_id" => "#{guest.guest_id}\nAlamat: #{guest.alamat}\nKategori: #{guest.kategori}",
        "nama"     => guest.nama,
        "alamat"   => guest.alamat,
        "other1"   => guest.other1,
        "other2"   => guest.other2,
        "other3"   => guest.other3,
        "hasil"    => false
      }

      # If the selected column is already present, return the response
      if guest.send(selected_column).present?
        return render json: data, status: :ok
      end

      # Set the selected column to the current time
      guest.send("#{selected_column}=", Time.now())

      if guest.save
        data["message"] = "Selamat Datang"
        data["hasil"]   = true
        render json: data, status: :ok
      else
        # If save fails, rollback the transaction and return an error response
        raise ActiveRecord::Rollback # this ensures rollback if save fails
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    # Handle the case where an exception was raised
    render json: {
      message:  "Terjadi kesalahan, Silahkan coba kembali",
      guest_id: "",
      nama:     "Terjadi kesalahan, Silahkan coba kembali",
      alamat:   "",
      other1:   "",
      other2:   "",
      other3:   "",
      hasil:    false
    }, status:   :unprocessable_entity
  end

  def get_presence_field(classname, is_checkin)
    case classname
    when "Class01"
      is_checkin ? "presence_time" : "souvenir_time"
    when "Class02"
      is_checkin ? "presence_2_time" : "souvenir_2_time"
    when "Class03"
      is_checkin ? "presence_3_time" : "souvenir_3_time"
    when "Class04"
      is_checkin ? "presence_4_time" : "souvenir_4_time"
    else nil # Return nil if no valid match
    end
  end

  def render_index_page(title, classname)
    @title = title
    @classname = classname
    @settingwedd = Setting.first
    @event = Event.joins(:type_of_event)
                    .find_by(type_of_events: { name: 'Moving' }, status: true)

    if @event.nil?
      redirect_to root_path, alert: "Event Moving Class Belum Aktif"
    else
      render file: "#{Rails.root}/app/views/movings/index.html.erb", layout:'presence'
    end
  end
end

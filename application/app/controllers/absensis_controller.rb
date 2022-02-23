class AbsensisController < ApplicationController
  include PresencesHelper,ApplicationHelper
  helper_method :sort_column, :sort_direction

  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def index
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Absensi"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Absensi%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Absensi Belum Aktif"
    end
  end

  def show
    @absensi = Absensi.find(params[:id])
    @detail = @absensi.guest_id
    @searchid = Log.where(guest_id: @detail).all
    respond_to do |f|
      f.js
    end
  end

  def master
    if params[:search].present?
    @page = params[:page]
    @absensis = Absensi.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Absensi%'")
                       .where("events.status = TRUE")
                       .search(params[:search],params[:checkbox])
                       .page(@page).per(50)
    else
      @page = params[:page]
      @absensis = Absensi.joins(event: :type_of_event).where("type_of_events.name ilike  '%Absensi%'")
                      .where("events.status = TRUE")
                      .order(sort_column + " " + sort_direction)
                      .page(@page).per(50)
                    end
    if params[:reset_button]
      redirect_to master_absensis_path
    end
  end

  def masterdata
    if params[:name_search].present?
    @absensis = Absensi.joins(event: :type_of_event)
                       .search(params[:name_search])
    else
      @page = params[:page]


      @absensis = Absensi.joins(event: :type_of_event).where("type_of_events.name ilike  '%Absensi%'")
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
    Absensi.import(params[:file],params[:absensi][:event_id])
    redirect_to masterdata_absensis_path, notice: "Absensi guest imported"
  end

  def pengaturan
  end

  def reset
    event_id = Event.find_by(status: true).id
    absensi = Absensi.where(event_id: event_id)
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
    if params[:guest_qr].present?
      find_guest = Absensi.where("name ilike '%#{params[:guest_qr]}%'").limit(1)
      @qrcode = find_guest.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'absensis/print_qr' }
    end
  end

  def print_qr_master
    if params[:guest_id].present?
      find_guest2 = Absensi.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'absensis/print_qr_master' }
    end
  end

  def update_presence
    @find_guest = Absensi.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Absensi%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.souvenir != TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorker.perform_async(params[:guest_code],params[:name])
      @baru = Log.create(guest_id: params[:guest_code],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk")
      @presence = 'Sukses'
    # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != FALSE
         @baru = Log.create(guest_id: params[:guest_code],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk")
      @terakhir = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Masuk")
                     .order(waktu: :desc)
                     .limit(5)
      @terakhirkeluar = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Keluar")
                     .order(waktu: :desc)
                     .limit(5)
        @presence = 'Setelah'
    #Melakukan Reset CheckOut
        @resetcheckout = Absensi.where(guest_id: @find_guest.first.guest_id)
                                .where(event_id: @find_guest.first.event_id)
                                .update(:souvenir => false )
    # Sudah Masuk, Belum Keluar
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != TRUE
        @presence = 'Belum'
        @cekterakhir = Log.where(guest_id: @find_guest.first.guest_id)
                       .where(keterangan: "Masuk")
                       .last
    # Non Ident
    elsif @find_guest.blank?
        @presence = 'Gagal'
    end
        respond_to do |format|
          format.js { render 'absensis/index' }
        end
  end

  #for mobile presence
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_presence_mobile
    @find_guest = Absensi.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Absensi%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Absensi%'").first.id.to_s
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.souvenir != TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorker.perform_async(params[:guest_code],params[:name])
      @baru = Log.create(guest_id: params[:guest_code],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk")
      @presence = 'Sukses'
    # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != FALSE
         @baru = Log.create(guest_id: params[:guest_code],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk")
      @terakhir = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Masuk")
                     .order(waktu: :desc)
                     .limit(5)
      @terakhirkeluar = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Keluar")
                     .order(waktu: :desc)
                     .limit(5)
        @presence = 'Setelah'
    #Melakukan Reset CheckOut
        @resetcheckout = Absensi.where(guest_id: @find_guest.first.guest_id)
                                .where(event_id: @find_guest.first.event_id)
                                .update(:souvenir => false )
    # Sudah Masuk, Belum Keluar
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != TRUE
        @presence = 'Belum'
        @cekterakhir = Log.where(guest_id: @find_guest.first.guest_id)
                       .where(keterangan: "Masuk")
                       .last
    # Non Ident
    elsif @find_guest.blank?
        @presence = 'Gagal'
    end
    respond_to do |format|
      case @presence
      when 'Sukses'
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
        }
      when 'Setelah'
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
    when 'Belum'
        format.json { render json:{
          message: "Belum", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      else
        format.json { render json:{
          message: "Tolak", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      end
    end
  end

  def souvenirmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_souvenir_mobile
    @find_guest = Absensi.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Absensi%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Absensi%'").first.id.to_s
    # Sudah Masuk, Belum Keluar (Sudah CheckIN)
    if @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != TRUE
      SouvenirWorker.perform_async(params[:souvenir],params[:name])
          @baru = Log.create(guest_id: params[:souvenir],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Keluar")
      @terakhir = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Keluar")
                     .order(waktu: :desc)
                     .limit(5)
      @terakhirmasuk = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Masuk")
                     .order(waktu: :desc)
                     .limit(5)
      @souvenir = 'Sukses'
    # Belum Masuk, Belum Keluar (Belum CheckIN)
    elsif @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.souvenir != TRUE
      @souvenir = 'Belum'
    # Sudah Masuk, Sudah Keluar (Sudah Semua, Mohon Check Masuk ke pintu CheckIN)
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != FALSE
      @souvenir = 'Sudah'
      @cekterakhir = Log.where(guest_id: @find_guest.first.guest_id)
                        .where(keterangan: "Keluar")
                        .last
    # Non Ident
    elsif @find_guest.blank?
      @souvenir = 'Gagal'
    end
    #filter
    respond_to do |format|
      case @souvenir
      when 'Sukses'
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
        }
      when 'Belum'
        format.json { render json:{
          message: "Belum", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      when 'Sudah'
        format.json { render json:{
          message: "Already", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      else
        format.json { render json:{
          message: "Tolak", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      end
    end
  end
#end for mobile

  def printulang
    render layout: 'presence'
  end

  def reprint
    @find_guest = Absensi.where(guest_id: params[:guest_code])

    if @find_guest.present? && @find_guest.first.presence == TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @print = {}
      respond_to do |format|
        format.js { render 'absensis/reprint' }
      end
    else
      respond_to do |format|
        format.js { render 'absensis/index' }
      end
    end
  end

   def create
    
    @query = Event.joins(:type_of_event)
                      .where(status:true)
                      .where("type_of_events.name ilike '%Absensi%'")
    # get kode from event
    # count record
    @total_person = Absensi.where(event_id: @query.first.id.to_s).count
    # +1 the count record
    @total_person += 1
    # using str pad
    @temp_id = @total_person.to_s.rjust(4,'0')
    # concat with kode from event
    @result_id = @query.first.code.to_s + @temp_id
    absensi_params[:guest_id] = @result_id
    absensi_params[:presence] = true
    absensi_params[:time_of_entry] = Time.now()
    @absensi = Absensi.create(absensi_params)
     if @absensi.save
        redirect_to new_absensi_path, notice:"Tambah Data Berhasil !!!"
      else
        redirect_to new_absensi_path, alert:"Gagal Tambah Data, Mohon Cek Form"
      end
   end

  def new
    @absensi = Absensi.new
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Absensi"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Absensi%'").first.id.to_s
    else
          redirect_to masterdata_absensis_path, alert:"Event Absensi Belum Aktif"
    end
  end

  def edit
    @absensi = Absensi.find(params[:id])
  end

  def update
      @absensi = Absensi.find(params[:id])
      if @absensi.update(absensi_params)
      redirect_to master_absensis_path, notice: "Berhasil Edit"
      else
      redirect_to master_absensis_path, alert: "Gagal Edit"
      end
  end

  def destroy
     @absensi = Absensi.find(params[:id])
     @absensi.destroy
     @absensilog = Log.where(guest_id: @absensi.guest_id)
     @absensilog.delete_all
     redirect_to master_absensis_path, notice: "Berhasil Hapus Data"
   end

   def souvenir
     @settingwedd = Setting.first
     @checkaktif = TypeOfEvent.joins(:events)
                         .where("events.status":true)
                         .first.name
     if @checkaktif == "Absensi"
       @eventid = Event.joins(:type_of_event)
                           .where(status:true)
                           .where("type_of_events.name ilike '%Absensi%'").first.id.to_s
       render layout: 'presence'
     else
       redirect_to root_path, alert:"Event Absensi Belum Aktif"
     end
   end

  def update_souvenir
    @find_guest = Absensi.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Absensi%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
    # Sudah Masuk, Belum Keluar (Sudah CheckIN)
    if @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != TRUE
      SouvenirWorker.perform_async(params[:souvenir],params[:name])
          @baru = Log.create(guest_id: params[:souvenir],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Keluar")
      @terakhir = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Keluar")
                     .order(waktu: :desc)
                     .limit(5)
      @terakhirmasuk = Log.where(guest_id: @find_guest.first.guest_id)
                     .where(keterangan: "Masuk")
                     .order(waktu: :desc)
                     .limit(5)
      @souvenir = 'Sukses'
    # Belum Masuk, Belum Keluar (Belum CheckIN)
    elsif @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.souvenir != TRUE
      @souvenir = 'Belum'
    # Sudah Masuk, Sudah Keluar (Sudah Semua, Mohon Check Masuk ke pintu CheckIN)
    elsif @find_guest.present? && @find_guest.first.presence != FALSE && @find_guest.first.souvenir != FALSE
      @souvenir = 'Sudah'
      @cekterakhir = Log.where(guest_id: @find_guest.first.guest_id)
                        .where(keterangan: "Keluar")
                        .last
    # Non Ident
    elsif @find_guest.blank?
      @souvenir = 'Gagal'
  else 
    @souvenir ='Belum'
  end
    respond_to do |format|
      format.js { render 'absensis/index' }
    end
  end

  def print_qr_page
    render layout: 'presence'
  end

  def update_print_qr_page
  end

  def dashboard
    content = {}
    flash[:notice] = "Refresh Data Berhasil !!!"
    @total_guest = Absensi.joins(:event).where("events.status=true").count
    @guest_sudah_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=true").count
    @guest_belum_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=false").count
    @jumlah_souvenir = Absensi.joins(:event).where("events.status=true").where("absensis.souvenir=true").count
    @jenis_kategori = Absensi.joins(:event).where("events.status=true")
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

  def clientview
    content = {}
    @total_guest = Absensi.joins(:event).where("events.status=true").count
    @guest_sudah_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=true").count
    @guest_belum_hadir = Absensi.joins(:event).where("events.status=true").where("absensis.presence=false").count
    @jumlah_souvenir = Absensi.joins(:event).where("events.status=true").where("absensis.souvenir=true").count
    @jenis_kategori = Absensi.joins(:event).where("events.status=true")
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
    @setting = Setting.first
    @events = TypeOfEvent.joins(:events).where(name:"Absensi").select("events.name as name,events.id as id")
    @guests = Log.where(event_id:params[:event_id]).order(guest_id: :asc)
    @guestsfalse = Absensi.where(event_id:params[:event_id]).where(presence: :false).order(guest_id: :asc)
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_absensi
    unless params[:event].nil?
      if params[:jenis_kategori].present?
        data_hadir = Absensi.joins(:event)
                           .where("events.name like '%#{params[:event][:event_id]}%'")
                          .where(presence:true)
        data_tidak_hadir = Absensi.joins(:event)
                                .where("events.name like '%#{params[:event][:event_id]}%'")
                                .where('absensis.presence = false or absensis.presence = null')
        @report = tentukan_jenis_report(params[:jenis_kategori],data_hadir,data_tidak_hadir,params[:presence_kategori])
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
    @exports= Absensi.joins(:event).where("events.name like '%#{params[:event]}%'")
    respond_to do |format|
      format.xls
    end
  end


  private

  def absensi_params
    @absensi_params ||= params.require(:absensi).permit(:guest_id, :nama, :event_id, :kategori, :alamat, :instansi, :jabatan, :unit_kerja)
  end

  def sort_column
    params[:sort] || "nama"
  end

  def sort_direction
    params[:direction] || "asc"
  end
end

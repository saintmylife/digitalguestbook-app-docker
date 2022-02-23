class MovingsController < ApplicationController
  include PresencesHelper,ApplicationHelper
  helper_method :sort_column, :sort_direction

  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def index
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end
# kelas controller
  def class2
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class3
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class4
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class5
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class6
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class7
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class8
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class9
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

  def class10
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Moving Class Belum Aktif"
    end
  end

# END CLASS CONTROLLER
  def show
    @moving = Moving.find(params[:id])
    @detail = @moving.guest_id
    @searchid = Logmoving.where(guest_id: @detail).all
    respond_to do |f|
      f.js
    end
  end

  def master
    if params[:search].present?
    @page = params[:page]
    @movings = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .search(params[:search],params[:checkbox])
                       .page(@page).per(50)
    else
      @page = params[:page]
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
    Moving.import(params[:file],params[:moving][:event_id])
    redirect_to masterdata_movings_path, notice: "Moving guest imported"
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
      find_guest2 = Moving.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'movings/print_qr_master' }
    end
  end

  def update_presence
    @find_guest = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
    #start-debug-class
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
    else "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    #end-debug-class
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorkerMovingClass.perform_async(params[:guest_code],params[:classname])
      # Masuk ke log
        @baru = Logmoving.create(guest_id: params[:guest_code],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk",kelas: params[:classname])
      # end masuk ke log
      @presence = 'Sukses'
    # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      # Masuk ke log
        @baru = Logmoving.create(guest_id: params[:guest_code],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk",kelas: params[:classname])
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
        #Melakukan Reset CheckOut
        @resetcheckout = Moving.where(guest_id: @find_guest.first.guest_id)
                                .where(event_id: @find_guest.first.event_id)
        case params[:classname]
        when "Class1"
          @resetcheckoutdone = @resetcheckout.update(:souvenir => false )
        when "Class2"
          @resetcheckoutdone = @resetcheckout.update(:souvenir2 => false )
        when "Class3"
          @resetcheckoutdone = @resetcheckout.update(:souvenir3 => false )
        when "Class4"
          @resetcheckoutdone = @resetcheckout.update(:souvenir4 => false )
        when "Class5"
          @resetcheckoutdone = @resetcheckout.update(:souvenir5 => false )
        when "Class6"
          @resetcheckoutdone = @resetcheckout.update(:souvenir6 => false )
        when "Class7"
          @resetcheckoutdone = @resetcheckout.update(:souvenir7 => false )
        when "Class8"
          @resetcheckoutdone = @resetcheckout.update(:souvenir8 => false )
        when "Class9"
          @resetcheckoutdone = @resetcheckout.update(:souvenir9 => false )
        when "Class10"
          @resetcheckoutdone = @resetcheckout.update(:souvenir10 => false )
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

  #for mobile presence
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_presence_mobile
    @find_guest = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    #start-debug-class
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
    else "Class10"
      @class_check = @find_guest.select("presence10 as cek_masuk, souvenir10 as cek_keluar").first
    end
    #end-debug-class
    # Belum masuk, Belum Keluar, Pertamakali
    if @find_guest.present? && @class_check.cek_masuk != TRUE && @class_check.cek_keluar != TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorkerMovingClass.perform_async(params[:guest_code],params[:classname])
      # Masuk ke log
        @baru = Logmoving.create(guest_id: params[:guest_code],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk",kelas: params[:classname])
      # end masuk ke log
      # JSON ke mobileapps
      respond_to do |format|
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.jabatan,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: true, # ini buat logo
        },status:200
      }
      end
      # end json ke mobileapps
    # Sudah Masuk, Sudah Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != FALSE
      # Masuk ke log
        @baru = Logmoving.create(guest_id: params[:guest_code],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Masuk",kelas: params[:classname])
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
        #json ke mobile apps
        #end json ke mobile apps
        respond_to do |format|
          format.json { render json:{
            message: "Silahkan Check In", #data yang mau ditampilkan di app
            guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
            nama: @find_guest.first.nama,
            alamat: @find_guest.first.alamat,
            other1: "other1",
            other2: "other2",
            other3: "other3",
            hasil: false, # ini buat logo
          },status:200
        }
        end
        #Melakukan Reset CheckOut
        @resetcheckout = Moving.where(guest_id: @find_guest.first.guest_id)
                                .where(event_id: @find_guest.first.event_id)
        case params[:classname]
        when "Class1"
          @resetcheckoutdone = @resetcheckout.update(:souvenir => false )
        when "Class2"
          @resetcheckoutdone = @resetcheckout.update(:souvenir2 => false )
        when "Class3"
          @resetcheckoutdone = @resetcheckout.update(:souvenir3 => false )
        when "Class4"
          @resetcheckoutdone = @resetcheckout.update(:souvenir4 => false )
        when "Class5"
          @resetcheckoutdone = @resetcheckout.update(:souvenir5 => false )
        when "Class6"
          @resetcheckoutdone = @resetcheckout.update(:souvenir6 => false )
        when "Class7"
          @resetcheckoutdone = @resetcheckout.update(:souvenir7 => false )
        when "Class8"
          @resetcheckoutdone = @resetcheckout.update(:souvenir8 => false )
        when "Class9"
          @resetcheckoutdone = @resetcheckout.update(:souvenir9 => false )
        when "Class10"
          @resetcheckoutdone = @resetcheckout.update(:souvenir10 => false )
        end
    # Sudah Masuk, Belum Keluar
    elsif @find_guest.present? && @class_check.cek_masuk != FALSE && @class_check.cek_keluar != TRUE
        #json ke mobile apps
        respond_to do |format|
          format.json { render json:{
            message: "Belum Checkout", #data yang mau ditampilkan di app
            guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
            nama: @find_guest.first.nama,
            alamat: @find_guest.first.alamat,
            other1: "other1",
            other2: "other2",
            other3: "other3",
            hasil: false, # ini buat logo
          },status:200
        }
        end
        #end json ke mobile apps
      # Cek terakhirmasuk
        @cekterakhir = Logmoving.where(guest_id: @find_guest.first.guest_id)
                       .where(keterangan: "Masuk")
                       .where(kelas: params[:classname])
                       .last
      # end cek terakhir
    # Non Ident
    else
      respond_to do |format|
        format.json { render json:{
          message: "Tolak", #data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
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
    @find_guest = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
    #start-debug-class
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
      SouvenirWorkerMovingClass.perform_async(params[:souvenir],params[:classname])
      # masuk ke logmoving
        @baru = Logmoving.create(guest_id: params[:souvenir],event_id: params[:eventid], nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Keluar",kelas: params[:classname])
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
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
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
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
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
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: false, # ini buat logo
        },status:200
      }
      else 'Gagal'
        format.json { render json:{
          message: "Tolak", #data yang mau ditampilkan di app
          guest_id: "#{@find_guest.first.guest_id} \n \n#{@find_guest.first.jabatan}",
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
    @find_guest = Moving.where(guest_id: params[:guest_code])

    if @find_guest.present? && @find_guest.first.presence == TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @print = {}
      respond_to do |format|
        format.js { render 'movings/reprint' }
      end
    else
      respond_to do |format|
        format.js { render 'movings/index' }
      end
    end
  end

   def create
     @moving = Moving.create(moving_params)
     if @moving.save
        redirect_to new_moving_path, notice:"Tambah Data Berhasil !!!"
      else
        redirect_to new_moving_path, alert:"Gagal Tambah Data, Mohon Cek Form"
      end
   end

  def new
    @moving = Moving.new
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Moving"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    else
          redirect_to masterdata_movings_path, alert:"Event Moving Class Belum Aktif"
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
     @checkaktif = TypeOfEvent.joins(:events)
                         .where("events.status":true)
                         .first.name
     if @checkaktif == "Moving"
       @eventid = Event.joins(:type_of_event)
                           .where(status:true)
                           .where("type_of_events.name ilike '%Moving%'").first.id.to_s
       render layout: 'presence'
     else
       redirect_to root_path, alert:"Event Moving Class Belum Aktif"
     end
   end

# CLASS SOUVENIR CONTROLLER
def souvenir2
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir3
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir4
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir5
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir6
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir7
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir8
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir9
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

def souvenir10
  @settingwedd = Setting.first
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Moving"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    render layout: 'presence'
  else
    redirect_to root_path, alert:"Event Moving Class Belum Aktif"
  end
end

# END CLASS CONTROLLER
  def update_souvenir
    @find_guest = Moving.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Moving%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    #start-debug-class
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
      SouvenirWorkerMovingClass.perform_async(params[:souvenir],params[:classname])
      # masuk ke logmoving
        @baru = Logmoving.create(guest_id: params[:souvenir],event_id: @eventid, nama: @find_guest.first.nama, alamat: @find_guest.first.alamat, instansi: @find_guest.first.instansi, jabatan: @find_guest.first.jabatan, unit_kerja: @find_guest.first.unit_kerja, other1: @find_guest.first.other1, other2: @find_guest.first.other2, other3: @find_guest.first.other3, waktu: Time.now(),keterangan: "Keluar",kelas: params[:classname])
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
    content = {}
    flash[:notice] = "Refresh Data Berhasil !!!"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Moving%'").first.id.to_s
    @total_guest = Moving.joins(:event).where("events.status=true").count
    @cekkelas = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .order(kelas: :asc)
                             .distinct.pluck(:kelas)

# KELAS 1
    @jumlah_guest_masuk_1 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class01")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_1 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class01")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 2
    @jumlah_guest_masuk_2 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class02")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_2 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class02")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 3
    @jumlah_guest_masuk_3 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class03")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_3 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class03")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 4
    @jumlah_guest_masuk_4 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class04")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_4 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class04")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 5
    @jumlah_guest_masuk_5 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class05")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_5 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class05")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 6
    @jumlah_guest_masuk_6 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class06")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_6 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class06")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 7
    @jumlah_guest_masuk_7 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class07")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_7 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class07")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 8
    @jumlah_guest_masuk_8 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class08")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_8 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class08")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 9
    @jumlah_guest_masuk_9 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class09")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_9 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class09")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count
# KELAS 10
    @jumlah_guest_masuk_10 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class10")
                             .where(keterangan: "Masuk")
                             .distinct.pluck(:guest_id)
                             .count
    @jumlah_guest_keluar_10 = Logmoving.where(event_id: @eventid)
                             .where(status: true)
                             .where(kelas: "Class10")
                             .where(keterangan: "Keluar")
                             .distinct.pluck(:guest_id)
                             .count

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
    @events = TypeOfEvent.joins(:events).where(name:"Moving").select("events.name as name,events.id as id")
    @guests = Logmoving.where(event_id:params[:event_id]).where(status: :true).order(guest_id: :asc)
    @guestsfalse = Moving.where(event_id:params[:event_id])
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

  def moving_params
    params.require(:moving).permit(:guest_id, :nama, :event_id, :kategori, :alamat, :instansi, :jabatan, :unit_kerja)
  end

  def sort_column
    params[:sort] || "nama"
  end

  def sort_direction
    params[:direction] || "asc"
  end
end

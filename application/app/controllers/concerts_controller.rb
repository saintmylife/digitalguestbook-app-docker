class ConcertsController < ApplicationController
  include PresencesHelper,ApplicationHelper
  helper_method :sort_column, :sort_direction

  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def index
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Concert"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Concert%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Concert Belum Aktif"
    end
  end

  def master
    if params[:search].present?
    @page = params[:page]
    @concerts = Concert.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Concert%'")
                       .where("events.status = TRUE")
                       .search(params[:search],params[:checkbox])
                       .page(@page).per(50)
    else
      @page = params[:page]
      @concerts = Concert.joins(event: :type_of_event).where("type_of_events.name ilike  '%Concert%'")
                      .where("events.status = TRUE")
                      .order(sort_column + " " + sort_direction)
                      .page(@page).per(50)
                    end
    if params[:reset_button]
      redirect_to master_concerts_path
    end
  end

  def masterdata
    if params[:name_search].present?
    @concerts = Concert.joins(event: :type_of_event)
                       .search(params[:name_search])
    else
      @page = params[:page]


      @concerts = Concert.joins(event: :type_of_event).where("type_of_events.name ilike  '%Concert%'")
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
    Concert.import(params[:file],params[:concert][:event_id])
    redirect_to masterdata_concerts_path, notice: "Concert guest imported"
  end

  def pengaturan
  end

  def reset
    event_id = Event.find_by(status: true).id
    concert = Concert.where(event_id: event_id)
    concert.update_all(:presence => false, :time_of_entry => nil)
    redirect_to concerts_path, notice: "Concert reset"
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
      find_guest = Concert.where("name ilike '%#{params[:guest_qr]}%'").limit(1)
      @qrcode = find_guest.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'concerts/print_qr' }
    end
  end

  def print_qr_master
    if params[:guest_id].present?
      find_guest2 = Concert.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'concerts/print_qr_master' }
    end
  end

  def update_presence
    @find_guest = Concert.joins(event: :type_of_event)
                          .where("type_of_events.name ilike  '%Concert%'")
                          .where("events.status = TRUE")
                          .where(guest_id: params[:guest_code])
    if @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.kategori != "KWITANSI"
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorker.perform_async(params[:guest_code],params[:name])
      respond_to do |format|
        format.js { render 'concerts/update_presence' }
      end
    else
      @presence = if @find_guest.first.presence == TRUE
        TRUE
      else
        FALSE
      end
      respond_to do |format|
        format.js { render 'concerts/index' }
      end
    end
  end

  #for mobile presence
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_presence_mobile
    @find_guest = Concert.joins(event: :type_of_event)
                          .where("type_of_events.name ilike  '%Concert%'")
                          .where("events.status = TRUE")
                          .where(guest_id: params[:guest_code])
    if @find_guest.present? && @find_guest.first.presence != TRUE && @find_guest.first.kategori != "KWITANSI"
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      ScanWorker.perform_async(params[:guest_code],params[:name])
      respond_to do |format|
        format.json { render json:{
          message: "Success", #data yang mau ditampilkan di app
          guest_id: @find_guest.first.guest_id,
          nama: @find_guest.first.nama,
          alamat: @find_guest.first.alamat,
          other1: "other1",
          other2: "other2",
          other3: "other3",
          hasil: true, # ini buat logo
        },status:200
      }
      end
    else
      if @find_guest.first.presence == true
        respond_to do |format|
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
        end
      else
        respond_to do |format|
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
  end

  def souvenirmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_souvenir_mobile
    @find_guest = Concert.joins(event: :type_of_event)
                          .where("type_of_events.name ilike  '%Concert%'")
                          .where("events.status = TRUE")
                          .where(guest_id: params[:souvenir])
    if @find_guest.present? && @find_guest.first.ticket != TRUE && @find_guest.first.kategori != "TIKET"
      @souvenir = 'Sukses'
      SouvenirWorker.perform_async(params[:souvenir],params[:name])
    elsif @find_guest.present? && @find_guest.first.ticket == TRUE && @find_guest.first.kategori != "TIKET"
      @souvenir = 'Sudah'
    elsif @find_guest.blank? || @find_guest.first.kategori == "TIKET"
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
    @find_guest = Concert.where(guest_id: params[:guest_code])

    if @find_guest.present? && @find_guest.first.presence == TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @print = {}
      respond_to do |format|
        format.js { render 'concerts/reprint' }
      end
    else
      respond_to do |format|
        format.js { render 'concerts/index' }
      end
    end
  end

  def create
    @concert = Concert.create(concert_params)
    if @concert.save
          redirect_to new_concert_path, notice:"Tambah Data Berhasil !!!"
    else
          redirect_to new_concert_path, alert:"Gagal Tambah Data, Mohon Cek Form"
    end
  end

  def new
    @concert = Concert.new
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Concert"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Concert%'").first.id.to_s
    else
          redirect_to masterdata_concerts_path, alert:"Event Concert Belum Aktif"
    end
  end

  def edit
    @concert = Concert.find(params[:id])
  end

  def update
      @concert = Concert.find(params[:id])
      if @concert.update(concert_params)
      redirect_to master_concerts_path, notice: "Berhasil Edit"
      else
      redirect_to master_concerts_path, alert: "Gagal Edit"
      end
  end

  def destroy
     @concert = Concert.find(params[:id])
     @concert.destroy
     redirect_to master_concerts_path, notice: "Berhasil Hapus Data"
   end

   def souvenir
     @settingwedd = Setting.first
     @checkaktif = TypeOfEvent.joins(:events)
                         .where("events.status":true)
                         .first.name
     if @checkaktif == "Concert"
       @eventid = Event.joins(:type_of_event)
                           .where(status:true)
                           .where("type_of_events.name ilike '%Concert%'").first.id.to_s
       render layout: 'presence'
     else
       redirect_to root_path, alert:"Event Concert Belum Aktif"
     end
   end

  def update_souvenir
    @find_guest = Concert.joins(event: :type_of_event)
                          .where("type_of_events.name ilike  '%Concert%'")
                          .where("events.status = TRUE")
                          .where(guest_id: params[:souvenir])
    if @find_guest.present? && @find_guest.first.ticket != TRUE && @find_guest.first.kategori != "TIKET"
      @souvenir = 'Sukses'
      SouvenirWorker.perform_async(params[:souvenir],params[:name])
    elsif @find_guest.present? && @find_guest.first.ticket == TRUE && @find_guest.first.kategori != "TIKET"
      @souvenir = 'Sudah'
    elsif @find_guest.blank? || @find_guest.first.kategori == "TIKET"
      @souvenir = 'Gagal'
    end

    respond_to do |format|
      format.js { render 'concerts/index' }
    end
  end

  def print_qr_page
    render layout: 'presence'
  end

  def update_print_qr_page
  end

  def dashboard
    # TIKET
    content = {}
    @total_guest = Concert.joins(:event).where("events.status=true").where("concerts.kategori='TIKET'").count
    @guest_sudah_hadir = Concert.joins(:event).where("events.status=true").where("concerts.kategori='TIKET'").where("concerts.presence=true").count
    @guest_belum_hadir = Concert.joins(:event).where("events.status=true").where("concerts.kategori='TIKET'").where("concerts.presence=false").count
    # KWITANSI
    @total_souvenir = Concert.joins(:event).where("events.status=true").where("concerts.kategori='KWITANSI'").count
    @souvenir_sudah = Concert.joins(:event).where("events.status=true").where("concerts.kategori='KWITANSI'").where("concerts.ticket=true").count
    @souvenir_belum = Concert.joins(:event).where("events.status=true").where("concerts.kategori='KWITANSI'").where("concerts.ticket=false").count
    # DETAIL JENIS_TIKET
    @jenis_tiket = Concert.joins(:event).where("events.status=true AND kategori = 'KWITANSI'")
              .select("
                        class_user,
                        COUNT(concerts.id) filter (where ticket = TRUE) as Hadir,
                        COUNT(concerts.id) filter (where ticket = FALSE) as TidakHadir
                      ")
              .group("class_user")
              .order(class_user: :asc)
    # DETAIL TIKET
    @kelas = Concert.joins(:event).where("events.status=true AND kategori = 'TIKET'")
              .select("
                        class_user,
                        COUNT(concerts.id) filter (where presence = TRUE) as Hadir,
                        COUNT(concerts.id) filter (where presence = FALSE) as TidakHadir
                      ")
              .group("class_user")
              .order(class_user: :asc)
  end

  def report
    @setting = Setting.first
    @events = TypeOfEvent.joins(:events).where(name:"Concert").select("events.name as name,events.id as id")
    @guests = Concert.where(event_id:params[:event_id]).order(guest_id: :asc)

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_concert
    unless params[:event].nil?
      if params[:jenis_kategori].present?
        data_hadir = Concert.joins(:event)
                           .where("events.name like '%#{params[:event][:event_id]}%'")
                          .where(presence:true)
        data_tidak_hadir = Concert.joins(:event)
                                .where("events.name like '%#{params[:event][:event_id]}%'")
                                .where('concerts.presence = false or concerts.presence = null')
        @report = tentukan_jenis_report(params[:jenis_kategori],data_hadir,data_tidak_hadir,params[:presence_kategori])
      end

      @no = if params[:page].to_i == 1 || params[:page].blank?
        1
      else
        (params[:page].to_i * 100) - 100 + 1
      end

      respond_to do |format|
        format.js { render '/concerts/report_wedding' }
      end
    else
      @jenis_kategori = delete_duplicate_value(Concert.select(:category))
    end
  end

  def export_excel
    @custom_header = Setting.all
    @exports= Concert.joins(:event).where("events.name like '%#{params[:event]}%'")
    respond_to do |format|
      format.xls
    end
  end


  private

  def concert_params
    params.require(:concert).permit(:guest_id, :nama, :event_id, :kategori, :alamat, :no_ktp, :no_ponsel, :email, :jenis_tiket, :class_user, :jumlah_tiket)
  end

  def sort_column
    params[:sort] || "nama"
  end

  def sort_direction
    params[:direction] || "asc"
  end
end

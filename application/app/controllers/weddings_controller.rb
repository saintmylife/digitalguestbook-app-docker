class WeddingsController < ApplicationController
  include PresencesHelper,ApplicationHelper
  helper_method :sort_column, :sort_direction

http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def import
    if Guest.import(params[:file],params[:guest][:event_id])
      @r = true
    respond_to do |f|
      f.js
    end
  else
  respond_to do |f|
    f.js
  end
end
  end

  def index
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Weddings"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Wedding%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Wedding Belum Aktif"
    end
  end

  def master
    @page = params[:page]
    @event = Event.where(status: true)
                  .where(type_of_event_id: 1)
                  .first

    if params[:search].present? || params[:direction] == nil
      @weddings = Guest.where(event_id: @event.id)
                       .search_live(params[:search])
                       .order(guest_id: :asc)
                       .page(@page).per(50)
    else
      @weddings = Guest.where(event_id: @event.id)
                       .order(sort_column + " " + sort_direction)
                       .page(@page).per(50)
    end
    if params[:reset_button]
      redirect_to master_weddings_path
    end
  end

  def master_live

  end

  def masterdata
    @event = Event.where(status: true)
                  .where(type_of_event_id: 1)
                  .first

    if params[:search].present?
      data = JSON.parse(params[:search])["data_search"]
      if data["data"] == "all"
        @weddings = Guest.where(event_id: @event.id)
                         .order(guest_id: :asc)
                         .page(params[:page]).per(50)
      else
        @weddings = search(data["name"], data["alamat"], data["kategori"])
      end
      respond_to do |f|
        f.js
      end
    else
      @page = params[:page]
      @weddings = Guest.where(event_id: @event.id)
                       .order(guest_id: :asc)
                       .page(@page).per(50)

      respond_to do |f|
        f.js
        f.html
      end
    end
  end

  def print
    render layout: false
  end

  def template_qr
    render layout: false
  end

  def template_qr_master
    render layout: false
    @find_guest = Guest.where(guest_id: params[:guest_id])
  end

  def print_qr
    if params[:guest_qr].present?
      # find_guest = Guest.where("nama ilike '%#{params[:guest_qr]}%'").limit(1)
      # find_guest = Guest.joins(event: :type_of_event).where("type_of_events.name ilike  '%Wedding%'")
      #                 .where("events.status = TRUE")
      #                 .where("nama ilike '%#{params[:guest_qr]}%'")
      #                 .limit(1)
      find_guest = Guest.joins(event: :type_of_event).where("type_of_events.name ilike  '%Wedding%'")
                      .where("events.status = TRUE")
                      # .where("guest_id ilike '%#{params[:guest_qr]}%'")
                      # update 6 dec
                      .where(guest_id: params[:guest_qr])
                      .limit(1)
      # @qrcode = find_guest.first.guest_id.to_s
      @qrcode = find_guest.first.guest_id.to_s

    end

    # ScanWorker.perform_async(find_guest.first.guest_id, "Weddings")

    respond_to do |format|
      format.js { render 'weddings/print_qr' }
    end
  end

  def print_qr_master
    if params[:guest_id].present?
      #update 6 dec 2021
      # find_guest2 = Guest.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      find_guest2 = Guest.joins(event: :type_of_event)
                         .where("type_of_events.name ilike '%Wedding%'")
                         .where("events.status = TRUE")
                         .where(guest_id: params[:guest_id])
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'weddings/print_qr_master' }
    end
  end

  #for mobile presence
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  # reset guest presence and souvenir
  def reset_presence_souvenir
    logger.info "duar is #{params[:guest_id]}"
    @find_guest = Guest.joins(event: :type_of_event)
                    .where("type_of_events.name ilike '%Wedding%'")
                    .where("events.status = TRUE")
                    .where(guest_id: params[:guest_id])
                    .first
    if @find_guest.present?
      logger.info "ada"
      ResetPresenceAndSouvenir.perform_async(@find_guest.guest_id,"Weddings",@find_guest.event_id)
      respond_to do |f|
          f.html {redirect_to master_weddings_path}
          f.js { render js: "window.top.location.reload(true);toastr['info']('Berhasil mereset <b>#{@find_guest.nama}</b>');" }
      end
    else
      respond_to do |f|
          f.js { render js: "toastr['info']('Gagal Mereset')" }
      end
    end
  end

  def update_presence_mobile
    @find_guest = Guest.joins(event: :type_of_event)
                       .where("type_of_events.name ilike '%Wedding%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
                       .first

    @settingan = Setting.select('id,nama_meja AS table, nama_angpao AS gift').last

    data = {
      "message"  => "ID Tidak Terdaftar",
      "guest_id" => "",
      "nama"     => "ID Tidak Terdaftar",
      "alamat"   => "",
      "other1"   => "",
      "other2"   => "",
      "other3"   => "",
      "kategori" => "",
      "rsvp"     => 0,
      "hasil"    => false
    }

    if @find_guest.present?
      data["message"] = "Already"
      if @find_guest.presence == false
        ScanWorker.perform_async(@find_guest.id, "Weddings")
        data["message"] = "Selamat Datang"
        data["hasil"]   = true
      end

      data["guest_id"]        = @find_guest.guest_id
      data["nama"]            = @find_guest.nama
      data["alamat"]          = @find_guest.alamat
      data["jumlah_undangan"] = @find_guest.jumlah_undangan
      data["other1"]          = @find_guest.nama_meja
      data["kategori"]        = @find_guest.kategori
      data["rsvp"]            = @find_guest.custom_two_text
      data["guest_status"]    = @find_guest.status
      data["setting"]         = @settingan

      data["guest_id"] = @find_guest.guest_id

      case @find_guest.event_id
      when 22 # Gamas & Viona
        data["guest_id"] << "\nAlamat #{@find_guest.alamat}"
      when 23 # Stephen & Natasya
        data["guest_id"] << "\nAlamat #{@find_guest.alamat}"
        data["guest_id"] << "\nNama Meja #{@find_guest.nama_meja}"
        data["guest_id"] << "\n#{@find_guest.custom_two_text}"
      when 24 # Inalum Golf
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nGolf: #{@find_guest.custom_three_text}"
      when 25 # Inalum Aluminium Talk
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nAluminum Talk: #{@find_guest.nama_meja}"
      when 26 # Inalum Gala Dinner
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nGala Dinner: #{@find_guest.nama_meja}"
      when 27 # Alfian & Chita
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 28 # Ninda & Redam
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 29 # Christian & Imelda
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}"
        data["guest_id"] << "\nNama Meja: #{@find_guest.nama_meja}"
      when 30 # NSS
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}\nKategori: #{@find_guest.kategori}"
      when 31 # Goza
        data["guest_id"] << "Pax: #{@find_guest.jumlah_undangan}\nMeja: #{@find_guest.nama_meja}"
      when 32 # Della & Nandar
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 65 # Nestle 18 Dec
        data["guest_id"] = ""
        data["nama"] = "Selamat Datang di\nNESTLE GOLDEN DAIRY AWARD 2024"
        data["nama"] << "\n\n#{@find_guest.nama}\n"
        data["nama"] << "Departemen: #{@find_guest.alamat}\nNo.Karyawan: #{@find_guest.kota}\nNama Meja: #{@find_guest.nama_meja}"
      when 66 # Nestle 19 Dec
        data["guest_id"] = ""
        data["nama"] = "Selamat Datang di\nNESTLE GOLDEN DAIRY AWARD 2024"
        data["nama"] << "\n\n#{@find_guest.nama}\n"
        data["nama"] << "Departemen: #{@find_guest.alamat}\nNama Meja: #{@find_guest.nama_meja}"
      when 67 # Thomas & Bella
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nKategori: #{@find_guest.kategori}"
      when 68 # Rifqy & Rica
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nNama Meja: #{@find_guest.nama_meja}"
      when 69 # William & Claudia
        data["guest_id"] << "\nNama Meja: #{@find_guest.nama_meja}"
        data["guest_id"] << "\nKategori: #{@find_guest.kategori}"
        if @find_guest.status == 'VIP'
          data["guest_id"] << "\nVIP"
        end
      when 70 # Prudential
        data["guest_id"] << "\n#{@find_guest.alamat}\n#{@find_guest.kota}\n#{@find_guest.kategori}"
      when 71 # Nabilah Huda
        data["guest_id"] << "\n#{@find_guest.alamat}\nKategori: #{@find_guest.kategori}\n#{@find_guest.status}"
      when 72 # RSI
        data["guest_id"] << "\n#{@find_guest.custom_three_text}\n#{@find_guest.status}"
      when 73 # HwaInd - Stellar Soire
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}"
      else
        # Noop
      end

    end

    respond_to do |format|
      format.json { render json: data, status: 200 }
    end
  end

  def souvenirmobile
    @settingwedd2 = Setting.first
    render layout: 'presence'
  end

  def update_souvenir_mobile
    @find_guest = Guest.joins(event: :type_of_event)
                       .where("type_of_events.name ilike 'Wedding%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
                       .first

    data = {
      "message"         => "ID Tidak Terdaftar",
      "guest_id"        => "",
      "nama"            => "ID Tidak Terdaftar",
      "alamat"          => "",
      "other1"          => "",
      "other2"          => "",
      "other3"          => "",
      "jumlah_undangan" => "",
      "kategori"        => "",
      "hasil"           => false,
    }

    if @find_guest.present?
      data["message"] = "Already"
      if @find_guest.souvenir == false
        SouvenirWorker.perform_async(@find_guest.id, "Weddings")
        data["message"] = "Terimakasih"
        data["hasil"]   = true
      end

      data["nama"]            = @find_guest.nama
      data["alamat"]          = @find_guest.alamat
      data["other1"]          = @find_guest.custom_one_text
      data["other2"]          = @find_guest.nama_meja
      data["other3"]          = @find_guest.jumlah_undangan
      data["jumlah_undangan"] = @find_guest.jumlah_undangan
      data["kategori"]        = @find_guest.kategori

      data["guest_id"] = @find_guest.guest_id

      case @find_guest.event_id
      when 22 # Gamas & Viona
        data["guest_id"] << "\nAlamat #{@find_guest.alamat}"
      when 23 # Stephen & Natasya
        data["guest_id"] << "\nAlamat #{@find_guest.alamat}"
        data["guest_id"] << "\nNama Meja #{@find_guest.nama_meja}"
        data["guest_id"] << "\n#{@find_guest.custom_two_text}"
      when 24 # Inalum Golf
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nGolf: #{@find_guest.custom_three_text}"
      when 25 # Inalum Aluminium Talk
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nAluminum Talk: #{@find_guest.nama_meja}"
      when 26 # Inalum Gala Dinner
        data["guest_id"] << "\n#{@find_guest.alamat}"
        data["guest_id"] << "\nGala Dinner: #{@find_guest.nama_meja}"
      when 27 # Alfian & Chita
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 28 # Ninda & Redam
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 29 # Christian & Imelda
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}"
        data["guest_id"] << "\nNama Meja: #{@find_guest.nama_meja}"
      when 30 # NSS
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}\nKategori: #{@find_guest.kategori}"
      when 31 # Goza
        data["guest_id"] << "Pax: #{@find_guest.jumlah_undangan}\nMeja: #{@find_guest.nama_meja}"
      when 32 # Della & Nandar
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nStatus: #{@find_guest.status}\nKategori: #{@find_guest.kategori}"
      when 65 # Nestle 18 Dec
        data["guest_id"] = ""
        data["nama"] = "Selamat Datang di\nNESTLE GOLDEN DAIRY AWARD 2024"
        data["nama"] << "\n\n#{@find_guest.nama}\n"
        data["nama"] << "Departemen: #{@find_guest.alamat}\nNo.Karyawan: #{@find_guest.kota}\nNama Meja: #{@find_guest.nama_meja}"
      when 66 # Nestle 19 Dec
        data["guest_id"] = ""
        data["nama"] = "Selamat Datang di\nNESTLE GOLDEN DAIRY AWARD 2024"
        data["nama"] << "\n\n#{@find_guest.nama}\n"
        data["nama"] << "Departemen: #{@find_guest.alamat}\nNama Meja: #{@find_guest.nama_meja}"
      when 67 # Thomas & Bella
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nKategori: #{@find_guest.kategori}"
      when 68 # Rifqy & Rica
        data["guest_id"] << "\nAlamat: #{@find_guest.alamat}\nNama Meja: #{@find_guest.nama_meja}"
      when 69
        data["guest_id"] << "\nNama Meja: #{@find_guest.nama_meja}"
        data["guest_id"] << "\nKategori: #{@find_guest.kategori}"
        if @find_guest.status == 'VIP'
          data["guest_id"] << "\nVIP"
        end
      when 70 #Prudential
        data["guest_id"] << "\n#{@find_guest.alamat}\n#{@find_guest.kota}\n#{@find_guest.kategori}"
      when 71 #Nabilah & Huda
        data["guest_id"] << "\n#{@find_guest.alamat}\nKategori: #{@find_guest.kategori}\n#{@find_guest.status}"
      when 72 # RSI
        data["guest_id"] << "\n#{@find_guest.custom_three_text}\n#{@find_guest.status}"
      when 73 # HwaInd - Stellar Soire
        data["guest_id"] << "\nKeterangan: #{@find_guest.alamat}"
      else
        # Noop
      end
    end

    respond_to do |format|
      format.json { render json: data, status: 200 }
    end
  end
#end for mobile
  def update_presence
    @find_guest = Guest.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Wedding%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:guest_code])
    if @find_guest.present? && @find_guest.first.presence != true
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorker.perform_async(@find_guest.first.id,params[:name])
        respond_to do |format|
          format.js { render 'weddings/update_presence' }
        end
    else
      @presence = if @find_guest.first.presence == true
        true
      else
        false
      end
      respond_to do |format|
        format.js { render 'weddings/index' }
      end
    end
  end
  def printulang
    render layout: 'presence'
  end
  def reprint
    @find_guest = Guest.where(guest_id: params[:guest_code])

    if @find_guest.present? && @find_guest.first.presence == TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @print = {}
      respond_to do |format|
        format.js { render 'weddings/reprint' }
      end
    else
      respond_to do |format|
        format.js { render 'weddings/index' }
      end
    end
  end
# data manual
def datamanual
  @datamanual = Guest.new
  @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Wedding%'").first.id.to_s

  ##
end
#
def new
  @wedding = Guest.new
  @checkaktif = TypeOfEvent.joins(:events)
                      .where("events.status":true)
                      .first.name
  if @checkaktif == "Weddings"
    @eventid = Event.joins(:type_of_event)
                        .where(status:true)
                        .where("type_of_events.name ilike '%Wedding%'").first.id.to_s
  else
        redirect_to masterdata_weddings_path, alert:"Event Wedding Belum Aktif"
  end
end

  def create
    @wedding = Guest.create(guest_params)
    redirect_to new_wedding_path(@guest)
  end

  def edit
    @wedding = Guest.find(params[:id])
  end

  def update
      @wedding = Guest.find(params[:id])
      if @wedding.update
      redirect_to new_wedding_path(@wedding), alert: "Berhasil Edit"
      else
      redirect_to new_wedding_path(@wedding), alert: "Gagal Edit"
      end
  end

  def destroy
     @wedding = Guest.find(params[:id])
     @wedding.destroy
     redirect_to master_weddings_path, notice: "Berhasil Hapus Data"
   end

   def souvenir
     @settingwedd = Setting.first
     @checkaktif = TypeOfEvent.joins(:events)
                         .where("events.status":true)
                         .first.name
     if @checkaktif == "Weddings"
       @eventid = Event.joins(:type_of_event)
                           .where(status:true)
                           .where("type_of_events.name ilike '%Wedding%'").first.id.to_s
       render layout: 'presence'
     else
       redirect_to root_path, alert:"Event Wedding Belum Aktif"
     end
   end

  def update_souvenir
    @find_guest = Guest.joins(event: :type_of_event)
                       .where("type_of_events.name ilike  '%Wedding%'")
                       .where("events.status = TRUE")
                       .where(guest_id: params[:souvenir])
    if @find_guest.present? && @find_guest.first.souvenir != TRUE
      @souvenir = 'Sukses'
      SouvenirWorker.perform_async(@find_guest.first.id,params[:name])
    elsif @find_guest.present? && @find_guest.first.souvenir == TRUE
      @souvenir = 'Sudah'
    elsif @find_guest.blank?
      @souvenir = 'Gagal'
    end

    respond_to do |format|
      format.js { render 'weddings/index' }
    end
  end

  def print_qr_page
    render layout: 'presence'
  end

  def update_print_qr_page
  end

  def dashboard
    content = {}
    # @total_guest = Guest.joins(:event).where("events.status=true").where("guests.kategori = 'GUEST'").count
    @total_guest = Guest.joins(:event).where("events.status=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @total_orang = Guest.select("SUM (jumlah_undangan)").joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").sum("guests.jumlah_undangan")
    @total_vendor = Guest.joins(:event).where("events.status=true").where("guests.kategori='VENDOR'").where("guests.kategori != 'SYSTEM'").count
    # @guest_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori='GUEST'").count
    @guest_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    # @guest_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori='GUEST'").count
    @guest_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @vendor_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori='VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @vendor_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori='VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @jumlah_souvenir = Guest.joins(:event).where("events.status=true").where("guests.souvenir=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @souvenir_total = Guest.joins(:event).where("events.status=true").where("guests.souvenir=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").sum("CAST(guests.jumlah_souvenir as INTEGER)")

    # Buat Hitung Jumlah P/W
    @isEnabled = false
    @guestCountWoman = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'SYSTEM'").where("guests.custom_one_text = 'W'").count
    @personCountWoman = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'SYSTEM'").where("guests.custom_one_text = 'W'").sum("guests.jumlah_undangan")
    @guestCountOthers = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori = 'Tambahan'").count
    @personCountOthers = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori = 'Tambahan'").sum("guests.jumlah_undangan")
    @guestCountMan = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'SYSTEM'").where("guests.custom_one_text = 'L'").count
    @personCountMan = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'SYSTEM'").where("guests.custom_one_text = 'L'").sum("guests.jumlah_undangan")

    @units = Guest.joins(:event)
    .select("
        kategori,
        COUNT(*) as Total,
        COUNT(guests.id) filter (where presence = TRUE AND kategori != 'SYSTEM') as Hadir,
        COUNT(guests.id) filter (where presence = FALSE AND kategori != 'SYSTEM') as TidakHadir
      ")
      .group("kategori")
      .where("events.status=true")
      .where("guests.kategori!='SYSTEM'")
      .order(kategori: :asc)

      @total_guest_tambahan = Guest.joins(:event).where("events.status=true").where("guests.kategori = 'Tambahan'").count
      @guestSudahHadirPercentage = @guest_sudah_hadir.to_f / @total_guest * 100
      @guestBelumHadirPercentage = @guest_belum_hadir.to_f / @total_guest * 100
      @jumlahSouvenirPercentage = @jumlah_souvenir.to_f / @total_guest * 100

      render layout: 'dashboard'

      respond_to do |format|
        format.html
        format.js
      end
  end

  def dashboard_vip
    content = {}
    @total_guest_vip = Guest.joins(:event).where("events.status=true").where("guests.status = 'VIP' ").where("guests.presence = TRUE").count
    # @guest_vip = Guest.joins(:event).where("events.status=true AND kategori = 'VIP'")
    @guest_vip = Guest.joins(:event).where("events.status=true AND guests.status = 'VIP' AND presence=true ")
              .select("
                        nama as Nama,
                        kategori,
                        time_of_entry as Waktu
                      ")
              .group("nama")
              .group("waktu")
              .group("kategori")
              .order(time_of_entry: :desc)
              .limit(10) 
  end

  def dashboard_count
    content = {}
    # @total_guest = Guest.joins(:event).where("events.status=true").where("guests.kategori = 'GUEST'").count
    @total_guest = Guest.joins(:event).where("events.status=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @total_orang = Guest.select("SUM (jumlah_undangan)").joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").sum("guests.jumlah_undangan")
    # @guest_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori='GUEST'").count
    @guest_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    # @guest_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori='GUEST'").count
    @guest_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @vendor_sudah_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori='VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @vendor_belum_hadir = Guest.joins(:event).where("events.status=true").where("guests.presence=false").where("guests.kategori='VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @jumlah_souvenir = Guest.joins(:event).where("events.status=true").where("guests.souvenir=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count

    @total_undangan_masuk = Guest.joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @total_orang_masuk = Guest.select("SUM (jumlah_undangan)").joins(:event).where("events.status=true").where("guests.presence=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").sum("guests.jumlah_undangan") 

    @total_undangan_keluar = Guest.joins(:event).where("events.status=true").where("guests.souvenir=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").count
    @total_orang_keluar = Guest.select("SUM (jumlah_undangan)").joins(:event).where("events.status=true").where("guests.souvenir=true").where("guests.kategori != 'VENDOR'").where("guests.kategori != 'SYSTEM'").sum("guests.jumlah_undangan")

    @undangan_masuk = @total_undangan_masuk - @total_undangan_keluar
    @orang_masuk = @total_orang_masuk - @total_orang_keluar
  end

  def report
    @setting = Setting.first
    @events = TypeOfEvent.joins(:events).where(name:"Weddings").select("events.name as name,events.id as id").order('id DESC')
    @jenis_kategori = delete_duplicate_value(Guest.select(:kategori))
    if params[:event_id].present? && params[:jenis_kategori] == 'all'
      query = "event_id = #{params[:event_id]}"
    elsif params[:event_id].present? && params[:jenis_kategori] != 'all'
      # query = "event_id = #{params[:event_id]} AND kategori ilike '%#{params[:jenis_kategori]}%'"
      query = "event_id = #{params[:event_id]}"
    end
    @guests = Guest.where(query)
    @id = Guest.joins(event: :type_of_event)
               .where("type_of_events.name ilike '%Wedding%'")
               .where("events.status = TRUE")
               .select("guest_id")
               

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_wedding
    unless params[:event].nil?
      if params[:jenis_kategori].present?
        data_hadir = Guest.joins(:event)
                           .where("events.name like '%#{params[:event][:event_id]}%'")
                          .where(presence:true)
        data_tidak_hadir = Guest.joins(:event)
                                .where("events.name like '%#{params[:event][:event_id]}%'")
                                .where('guests.presence = false or guests.presence = null')
        @report = tentukan_jenis_report(params[:jenis_kategori],data_hadir,data_tidak_hadir,params[:presence_kategori])
      end

      @no = if params[:page].to_i == 1 || params[:page].blank?
        1
      else
        (params[:page].to_i * 100) - 100 + 1
      end

      respond_to do |format|
        format.js { render '/weddings/report_wedding' }
      end
    else
      @jenis_kategori = delete_duplicate_value(Guest.select(:category))
    end
  end

  def export_excel
    @custom_header = Setting.all
    @exports= Guest.joins(:event).where("events.name like '%#{params[:event]}%'")
    respond_to do |format|
      format.xls
    end
  end

  #QRCODE with camera
  def qr_checkin
    render layout:false
  end
  def qr_checkin2
    render layout:false
  end
  def newqr
    render layout:false
  end

  def update_guest_brought_api
    @guest = Guest.joins(event: :type_of_event)
                        .where("type_of_events.name ilike '#{params[:type]}%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:guest_code])            
    if @guest
      UpdateGuestBroughtWorker.new.perform(params[:type],params[:guest_code],params[:guest_brought].to_i)
      @update_guest_brought = true
    else
      @update_guest_brought = false
    end  
    respond_to do |format|
      if @update_guest_brought
        format.json { render json:{
          message: "Success",
          jumlah_undangan: @guest[0].jumlah_undangan
        },status:200}
      else
        format.json { render json:{
          message: "Failed"
        },staus:404}  
      end
    end
  end

  def update_test
    logger.debug('tes')
  end

  def update_real_person
    @find_guest = Guest.joins(event: :type_of_event)
                    .where("type_of_events.name ilike '%Wedding%'")
                    .where("events.status = TRUE")
                    .where(guest_id: params[:guest_code])
    if params[:real_person].present?
      if @find_guest.present?
        @find_guest.update(real_person: params[:real_person])
        respond_to do |format|
          format.json { render json:{
            message: "Success",
            guest: @find_guest
            },status:200}
        end
      else
          respond_to do |format|
            format.json { render json:{
              message: "Not Found",
              },status:404}
          end
      end
    else
      respond_to do |format|
        format.json { 
          render json:{
            message: "Guest Count is Required",
          },
          status:422}
      end
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:guest_id, :nama, :event_id, :alamat, :kategori, :nama_meja, :jumlah_undangan, :nomor_ponsel, :souvenir_text, :custom_one_text, :custom_two_text, :custom_three_text, :custom_four_text, :custom_five_text)
  end

  def sort_column
    params[:sort] || "nama"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end

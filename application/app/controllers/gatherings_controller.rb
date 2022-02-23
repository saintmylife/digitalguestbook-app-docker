class GatheringsController < ApplicationController
  include PresencesHelper,ApplicationHelper
  helper_method :sort_column, :sort_direction

http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :masterdata

  def index
    @settingwedd = Setting.first
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Gatherings"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Gathering%'").first.id.to_s
      render layout: 'presence'
    else
      redirect_to root_path, alert:"Event Gathering Belum Aktif"
    end
  end

  def master
    if params[:search].present?
    @page = params[:page]
    @gatherings = Gathering.joins(event: :type_of_event)
                            .where("type_of_events.name ilike  '%Gathering%'")
                            .where("events.status = TRUE")
                            .search(params[:search],params[:checkbox])
                            .page(@page).per(50)
    else
      @page = params[:page]
      @gatherings = Gathering.joins(event: :type_of_event).where("type_of_events.name ilike  '%Gathering%'")
                      .where("events.status = TRUE")
                      .order(sort_column + " " + sort_direction)
                      .page(@page).per(50)
                    end
    if params[:reset_button]
      redirect_to master_gatherings_path
    end
  end

  def masterdata
    if params[:search].present?
      data = JSON.parse(params[:search])["data_search"]
      if data["data"] == "all"
        @gatherings = Gathering.joins(event: :type_of_event).where("type_of_events.name ilike  '%Gathering%'")
                      .where("events.status = TRUE")
                      .order(nama_peserta: :asc)
                      .page(params[:page]).per(50)
      else
        @gatherings = search_gathering(data["name"],data["alamat"],data["kategori"])
      end
      respond_to do |f|
        f.js
      end
    else
      @gatherings = Gathering.joins(event: :type_of_event).where("type_of_events.name ilike  '%Gathering%'")
                      .where("events.status = TRUE")
                      .order(nama_peserta: :asc)
                      .page(params[:page]).per(50)
      respond_to do |f|
        f.html
      end
    end
  end

  # GET /guests/import
  def import
    Gathering.import(params[:file],params[:gathering][:event_id])
    redirect_to masterdata_gatherings_path, notice: "Gathering Guest Berhasil di Import"
  end

  def pengaturan
  end

  def reset
    event_id = Event.find_by(status: true).id
    gathering = Gathering.where(event_id: event_id)
    gathering.update_all(:presence => false, :time_of_entry => nil)
    redirect_to gatherings_path, notice: "Gathering reset"
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
      find_guest = Gathering.where("name ilike '%#{params[:guest_qr]}%'").limit(1)
      @qrcode = find_guest.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'gatherings/print_qr' }
    end
  end

  def print_qr_master
    if params[:guest_id].present?
      find_guest2 = Gathering.where("guest_id ilike '%#{params[:guest_id]}%'").limit(1)
      @find_guest = find_guest2.first.guest_id.to_s
    end

    respond_to do |format|
      format.js { render 'gatherings/print_qr_master' }
    end
  end

  def update_presence
    @find_guest = Gathering.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Gathering%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:guest_code])
    if @find_guest.present? && @find_guest.first.presence != true
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      @print = {}
      ScanWorker.perform_async(params[:guest_code],params[:name])
      respond_to do |format|
        format.js { render 'gatherings/update_presence' }
      end
    else
      @presence = if @find_guest.first.presence == true
        true
      else
        false
      end
      respond_to do |format|
        format.js { render 'gatherings/index' }
      end
    end
  end

  #for mobile
  def kehadiranmobile
    @settingwedd = Setting.first
    render layout: 'presence'
  end

  def update_presence_mobile
    @find_guest = Gathering.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Gathering%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:guest_code])
    if @find_guest.present? && @find_guest.first.presence != true
      setting = Setting.where(id:@find_guest.first.event_id)
      @settingan = Setting.last
      ScanWorker.perform_async(params[:guest_code],params[:name])
      respond_to do |format|
        format.json { render json:{
          message: "Selamat Datang", #data yang mau ditampilkan di app
          guest_id: "#{@find_guest[0].guest_id}\n#{@find_guest[0].jabatan} - #{@find_guest[0].category}",
          nama: @find_guest.first.nama_peserta,
          alamat: @find_guest.first.address,
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
            guest_id: "#{@find_guest[0].guest_id} \n #{@find_guest[0].category}",
            nama: @find_guest.first.nama_peserta,
            alamat: @find_guest.first.address,
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
            message: "ID Tidak Terdaftar", #data yang mau ditampilkan di app
            guest_id: "ID Tidak Terdaftar",
            nama: "",
            alamat: "",
            other1: "",
            other2: "",
            other3: "",
            hasil: false, # ini buat logo
          },status:200
        }
        end
      end
    end
  end

  def update_guest_brought_api
    @guest = Gathering.joins(event: :type_of_event)
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
          message: "Success"
        },status:200}
      else
        format.json { render json:{
          message: "Failed"
        },staus:404}  
      end
    end
  end

    def souvenirmobile
      @settingwedd = Setting.first
      render layout: 'presence'
    end

    def update_souvenir_mobile
      @find_guest = Gathering.joins(event: :type_of_event)
                          .where("type_of_events.name ilike  '%Gathering%'")
                          .where("events.status = TRUE")
                          .where(guest_id: params[:souvenir])
      if @find_guest.present? && @find_guest.first.souvenir != TRUE
        @souvenir = 'Sukses'
        SouvenirWorker.perform_async(params[:souvenir],params[:name])
      elsif @find_guest.present? && @find_guest.first.souvenir == TRUE
        @souvenir = 'Sudah'
      elsif @find_guest.blank?
        @souvenir = 'Gagal'
      end
      #filter
      respond_to do |format|
        case @souvenir
        when 'Sukses'
          format.json { render json:{
            message: "Terimakasih", #data yang mau ditampilkan di app
            guest_id: "#{@find_guest[0].guest_id}\n#{@find_guest[0].category}",
            nama: @find_guest.first.nama_peserta,
            alamat: @find_guest.first.address,
            other1: "#{@find_guest[0].jumlah_orang} Person",
            other2: @find_guest.first.guest_id,
            other3: "other3",
            jumlah_undangan: @find_guest.first.jumlah_orang,
            kategori: @find_guest[0].category,
            hasil: true, # ini buat logo
          },status:200
          }
        when 'Sudah'
          format.json { render json:{
            message: "Already", #data yang mau ditampilkan di app
            guest_id: "#{@find_guest[0].guest_id}\n#{@find_guest[0].category}",
            nama: @find_guest.first.nama_peserta,
            alamat: @find_guest.first.address,
            other1: "other1",
            other2: "other2",
            other3: "other3",
            kategori: @find_guest[0].category,
            hasil: false, # ini buat logo
          },status:200
        }
      else
          format.json { render json:{
            message: "ID Tidak Terdaftar", #data yang mau ditampilkan di app
            guest_id: "ID Tidak Terdaftar",
            nama: "",
            alamat: "",
            other1: "",
            other2: "",
            other3: "",
            kategori: "",
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
    @find_guest = Gathering.where(guest_id: params[:guest_code])

    if @find_guest.present? && @find_guest.first.presence == TRUE
      setting = Setting.where(id:@find_guest.first.event_id)
      @print = {}
      respond_to do |format|
        format.js { render 'gatherings/reprint' }
      end
    else
      respond_to do |format|
        format.js { render 'gatherings/index' }
      end
    end
  end

  def new
    @gathering = Gathering.new
    @checkaktif = TypeOfEvent.joins(:events)
                        .where("events.status":true)
                        .first.name
    if @checkaktif == "Gatherings"
      @eventid = Event.joins(:type_of_event)
                          .where(status:true)
                          .where("type_of_events.name ilike '%Gathering%'").first.id.to_s
    else
          redirect_to masterdata_gatherings_path, alert:"Event Gathering Belum Aktif"
    end
  end

  def create
    @gathering = Gathering.create(gathering_params)
    if @gathering.save
          redirect_to new_gathering_path, notice:"Tambah Data Berhasil !!!"
    else
          redirect_to new_gathering_path, alert:"Gagal Tambah Data, Mohon Cek Form"
    end
  end

  def edit
    @gathering = Gathering.find(params[:id])
  end

  def update
      @gathering = Gathering.find(params[:id])
      if @gathering.update(gathering_params)
      redirect_to master_gatherings_path, notice: "Berhasil Edit"
      else
      redirect_to master_gatherings_path, alert: "Gagal Edit"
      end
  end

  def destroy
     @gathering = Gathering.find(params[:id])
     @gathering.destroy
     redirect_to master_gatherings_path, notice: "Berhasil Hapus Data"
   end

   def souvenir
     @settingwedd = Setting.first
     @checkaktif = TypeOfEvent.joins(:events)
                         .where("events.status":true)
                         .first.name
     if @checkaktif == "Gatherings"
       @eventid = Event.joins(:type_of_event)
                           .where(status:true)
                           .where("type_of_events.name ilike '%Gathering%'").first.id.to_s
       render layout: 'presence'
     else
       redirect_to root_path, alert:"Event Gathering Belum Aktif"
     end
   end

  def update_souvenir
    @find_guest = Gathering.joins(event: :type_of_event)
                        .where("type_of_events.name ilike  '%Gathering%'")
                        .where("events.status = TRUE")
                        .where(guest_id: params[:souvenir])
    if @find_guest.present? && @find_guest.first.souvenir != TRUE
      @souvenir = 'Sukses'
      SouvenirWorker.perform_async(params[:souvenir],params[:name])
    elsif @find_guest.present? && @find_guest.first.souvenir == TRUE
      @souvenir = 'Sudah'
    elsif @find_guest.blank?
      @souvenir = 'Gagal'
    else
      @souvenir = 'Gagal'
    end
    respond_to do |format|
      format.js { render 'gatherings/index' }
    end
  end

  def print_qr_page
    render layout: 'presence'
  end

  def update_print_qr_page
  end

  def dashboard
    content = {}
    @total_guest = Gathering.joins(:event).where("events.status=true AND gatherings.category != 'SYSTEM'").count
    @guest_sudah_hadir = Gathering.joins(:event).where("events.status=true").where("gatherings.presence=true AND gatherings.category != 'SYSTEM'").count
    @guest_belum_hadir = Gathering.joins(:event).where("events.status=true").where("gatherings.presence=false AND gatherings.category != 'SYSTEM'").count
    # @units = Gathering.joins(:event)
    #           .select("
    #                     unit_kerja,
    #                     COUNT(*) as Total,
    #                     # COUNT(gatherings.id) filter (where presence = TRUE) as Hadir,
    #                     # COUNT(gatherings.id) filter (where presence = FALSE) as TidakHadir
    #                   ")
    #           .group("unit_kerja")
    #           .where("events.status=true")
    #           .order(unit_kerja: :asc)
    @units = Gathering.joins(:event)
                .select("
                    category,
                    COUNT(*) as Total,
                    COUNT(gatherings.id) filter (where presence = TRUE) as Hadir,
                    COUNT(gatherings.id) filter (where presence = FALSE) as TidakHadir
                  ")
                  .group("category")
                  .where("events.status=true")
                  .where("gatherings.category!='SYSTEM'")
                  .order(category: :asc)
    @jumlah_souvenir = Gathering.joins(:event).where("events.status=true").where("gatherings.souvenir=true").count
  end

  def report
    @setting = Setting.first
    @events = TypeOfEvent.joins(:events).where(name:"Gatherings").select("events.name as name,events.id as id").order('id DESC')
    @guests = Gathering.where(event_id:params[:event_id]).order(guest_id: :asc)

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def report_wedding
    unless params[:event].nil?
      if params[:jenis_kategori].present?
        data_hadir = Gathering.joins(:event)
                           .where("events.name like '%#{params[:event][:event_id]}%'")
                          .where(presence:true)
        data_tidak_hadir = Gathering.joins(:event)
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
        format.js { render '/gatherings/report' }
      end
    else
      @jenis_kategori = delete_duplicate_value(Gathering.select(:kategori))
    end
  end

  def export_excel
    @custom_header = Setting.all
    @exports= Gathering.joins(:event).where("events.name like '%#{params[:event]}%'")
    respond_to do |format|
      format.xls
    end
  end

  private

  def gathering_params
    params.require(:gathering).permit(:guest_id, :nama_peserta, :event_id, :nip, :address, :instansi, :category, :jabatan, :unit_kerja, :kelas)
  end

  def sort_column
    params[:sort] || "nama_peserta"
  end

  def sort_direction
    params[:direction] || "asc"
  end

end

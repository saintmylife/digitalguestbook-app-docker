class GuestsController < ApplicationController
  before_action :set_guest, only: [:show, :edit, :update, :destroy]
  include GuestsHelper
  layout 'application', :except => :print_no_undian


  # GET /guests
  # GET /guests.json
  def index
    @guests = GuestTemporary.all
    @guests1 = Guest.search(params[:name]).order(:nama).page(params[:page]).per(10)
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  # GET /guests/new
  def new
    @wedding = Guest.new
  end


  # POST /guests
  # POST /guests.json
  def create
    @code = Event.where("events.status=true").first
    @countInc = Guest.where("event_id=#{@code.id}").where("guest_id like ?", "#{@code.code}T%").count
    @countInc += 1
    @countInc = @countInc.to_s.rjust(3, '0')
    # auto checkin
    if params['autoID'].present? && params['autoID'] == 'on'
      params[:guest][:guest_id] = @code.code.to_s+"T"+@countInc
    end
    if params[:guest][:kategori].blank?
      params[:guest][:kategori] = 'Tambahan'
    end
    if params['autoPresence'].present? && params['autoPresence'] == 'on'
      params[:guest][:presence] = true
      params[:guest][:time_of_entry] = Time.now()
    end
    if params['autoPrint'].present? && params['autoPrint'] == 'on'
      @printQR = true
      @guestID = params[:guest][:guest_id]
    else
      @printQR = false
    end
    if params[:guest][:status].blank?
      params[:guest][:status] = '-'
    end
    @wedding = Guest.create(guest_params)
    if @wedding.save
      @con = true
      respond_to do |format|
        format.html { render 'weddings/new' }
        format.js { render 'weddings/new' }
        end
    else
      @con = false
      respond_to do |format|
        format.html { render 'weddings/new' }
        format.js { render 'weddings/new' }
        end
    end
  end

  # GET /guests/1/edit
  def edit
    @gwedding = Guest.find(params[:id])
  end


  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
      @wedding = Guest.find(params[:id])
      if params[:guest][:status].blank?
        params[:guest][:status] = '-'
      end
      if @wedding.update(guest_params)
         redirect_to master_weddings_path, notice: "Berhasil Edit Data"
      else
         redirect_to master_weddings_path, alert: "Gagal Edit Data"
      end

  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to guests_url, notice: 'Guest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /guests/import
  def import
    Guest.import(
      params[:file],
      params[:guest][:event_id],
    )
    redirect_to guests_path, notice: "Guests imported"
  end

  # GET /guests/presence
  def presence
    # if params[:guest_code].present?
    #   find_guest = Guest.where(guest_id: params[:guest_code])
    #   find_guest.update(presence:true)
    #   # @qrcode = RQRCode::QRCode.new(find_guest.first.no_undian.to_s,size: 0.1)
    #   # @png = @qrcode.as_png(
    #   #     resize_gte_to: false,
    #   #     resize_exactly_to: false,
    #   #     fill: 'white',
    #   #     color: 'black',
    #   #     size: 120,
    #   #     border_modules: 4,
    #   #     module_px_size: 6
    #   # )
    #   # send_data @png, filename: "no_undian_#{find_guest.first.no_undian.to_s}.png", type: @png
    #   redirect_to presence_guests_path, notice: 'ABSEN GUEST SUCCESSFULLY'
    # else
    #   # redirect_to presence_guests_path, notice: 'NOT FOUND'
    #   render presence_guests_path, notice: "NOT_FOUND"
    # end
  end

  def print_no_undian
    begin
      @find_guest = Guest.where(guest_id: params[:guest_code])
      @find_guest.update(presence:true)
    rescue
      render presence_guests_path, notice: "NOT_FOUND"
    end
  end

  #GET /guest/print_qr
  def print_qr
    qrcode = RQRCode::QRCode.new(params[:guest_id])
    @png = qrcode.as_png(
        resize_gte_to: false,
        resize_exactly_to: false,
        fill: 'white',
        color: 'black',
        size: 120,
        border_modules: 4,
        module_px_size: 6
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:guest_id, :nama, :event_id, :alamat, :kategori, :nama_meja, :jumlah_undangan, :presence ,:time_of_entry, :custom_one_text, :custom_two_text, :nomor_ponsel,:status)
    end
end

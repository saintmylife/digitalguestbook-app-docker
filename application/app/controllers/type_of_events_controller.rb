class TypeOfEventsController < ApplicationController
  before_action :set_type_of_event, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :only => [:search_person]

  # GET /type_of_events
  # GET /type_of_events.json
  def index
    @type_of_events = TypeOfEvent.search(params[:name]).page(params[:page]).per(5)
  end

  # GET /type_of_events/1
  # GET /type_of_events/1.json
  def show
  end

  # GET /type_of_events/new
  def new
    @type_of_event = TypeOfEvent.new
  end

  # GET /type_of_events/1/edit
  def edit
  end

  # POST /type_of_events
  # POST /type_of_events.json
  def create
    @type_of_event = TypeOfEvent.new(type_of_event_params)

    respond_to do |format|
      if @type_of_event.save
        format.html { redirect_to type_of_events_path, notice: 'Type of event was successfully created.' }
        format.json { render :show, status: :created, location: @type_of_event }
      else
        format.html { render :new }
        format.json { render json: @type_of_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_of_events/1
  # PATCH/PUT /type_of_events/1.json
  def update
    respond_to do |format|
      if @type_of_event.update(type_of_event_params)
        format.html { redirect_to type_of_events_url, notice: 'Type of event was successfully updated.' }
        format.json { render :show, status: :ok, location: @type_of_event }
      else
        format.html { render :edit }
        format.json { render json: @type_of_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_of_events/1
  # DELETE /type_of_events/1.json
  def destroy
    @type_of_event.destroy
    respond_to do |format|
      format.html { redirect_to type_of_events_url, notice: 'Type of event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def getalldata
    @checkaktif = TypeOfEvent.joins(:events)
                  .where("events.status":true)
                  .first.name
    case @checkaktif
    when 'Weddings'
      @all_guest = Guest.joins(:event).where("events.status=true").select("guests.id, guests.guest_id, guests.nama, guests.kategori, guests.presence as checkin, guests.souvenir as checkout").order(nama: :asc)
    when 'Concert'
      @all_guest = Concert.joins(:event).where("events.status=true").select("concerts.id, concerts.guest_id, concerts.nama, concerts.presence as checkin, concerts.ticket as checkout").order(nama: :asc)
    when 'Moving'
      @all_guest = Moving.joins(:event).where("events.status=true").select("movings.id, movings.guest_id, movings.nama, movings.presence as checkin, movings.souvenir as checkout").order(nama: :asc)
    when 'Absensis'
      @all_guest = Absensi.joins(:event).where("events.status=true").select("absensi.id, absensi.guest_id, absensi.nama, absensi.presence as checkin, absensi.souvenir as checkout").order(nama: :asc)
    else
      @all_guest = Gathering.joins(:event).where("events.status=true").select("gatherings.id, gatherings.guest_id, gatherings.nama_peserta as nama, gatherings.presence as checkin, gatherings.souvenir as checkout").order(nama_peserta: :asc)
    end
    if params[:q].present?
      if @checkaktif != 'Gatherings'
        @query = 'nama'
      else
        @query = 'nama_peserta'
      end  
      @all_guest = @all_guest.where("#{@query} ilike '%#{params[:q]}%'")
    end
    respond_to do |format|
      format.json {
        render json:{
          data: @all_guest
        }, status: 200
      }
    end
  end

  def search_person
    @person = Guest.joins(:event).where("events.status=true").select("guests.guest_id, guests.nama")
    respond_with @person
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_of_event
      @type_of_event = TypeOfEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_of_event_params
      params.require(:type_of_event).permit(:name)
    end
end

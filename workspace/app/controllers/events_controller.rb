class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :destroy
#  skip_before_action :verify_authenticity_token
  # GET /events
  # GET /events.json
  def index
    @events = Event.search(params[:name]).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
      @event = Event.find(params[:id])
      @eventdate = Event.where(id:params[:id]).first.date.to_s
      @eventstatus = @event.status.to_s
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.date = params[:event][:event_date].to_date
    @event.status = false

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
        format.js { render 'contoh' }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
      @event = Event.find(params[:id])
      respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: "Event was successfully Edited"}
      else
        format.html { redirect_to events_path, notice: "Event was failed Edited"}
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    DeleteMasterWorker.perform_async(params[:id])
    redirect_to events_path, notice: "Event was successfully deleted"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name,:event_owner,:status,:type_of_event_id,:date,:code)
    end

    def generate_date
      d = params.require(:date).permit(:date_event)

      return Date.new(d["date_event(1i)"].to_i,d["date_event(2i)"].to_i,d["date_event(3i)"].to_i)
    end

end

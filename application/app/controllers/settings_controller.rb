class SettingsController < ApplicationController
  include SettingsHelper

  http_basic_authenticate_with :name => "reddonedigital", :password => "digital0207", only: :index

  def index
    @event_active = Event.where('status = true').first
    # @events = Event.where('status = false').order(:name)
    @events = Event.where('status = false').order(date: :desc).page(params[:page]).per(5)
    @setting = Setting.first
    @check_box_settings = Setting.first
  end

  def aktifasi
    @event = Event.find(params[:id])
    @event_lama = Event.where('status = true')
    ActiveRecord::Base.transaction do
      @event_lama.update(status:false)
      @event.update(status:true)
    end
    redirect_to settings_path, notice: 'Event berhasil diupdate'
  end

  def output
    @display = Display.find(1)
    begin
      if params[:nama].present?
        @display.update_attributes(
          nama:false
        )
       else
         @display.update_attributes(
           nama:params[:nama].present? ? true : false,
         )
       end
     end
  end

  def update
    @setting = Setting.find(1)
    begin
      if params[:no_print].present?
        @setting.update_attributes(
          no_undian:false,
          nama_meja:false,
          nama_undangan:false,
          jumlah_souvenir:false,
          nama_angpao:false
        )
       else
         @setting.update_attributes(
           no_undian:params[:setting][:no_undian].present? ? true : false,
           nama_meja:params[:setting][:nama_meja].present? ? true : false,
           nama_undangan:params[:setting][:nama_undangan].present? ? true : false,
           jumlah_souvenir:params[:setting][:jumlah_souvenir].present? ? true : false,
           nama_angpao:params[:setting][:nama_angpao].present? ? true : false,
           custom_one_text:params[:setting][:custom_one_text].present? ? params[:setting][:custom_one_text] : nil,
           custom_two_text:params[:setting][:custom_two_text].present? ? params[:setting][:custom_two_text] : nil,
           jumlah_undangan:params[:setting][:jumlah_undangan].present? ? true : false
         )
       end
      @con = true
      respond_to do |format|
        format.js { render 'settings/index' }
      end
    rescue
      @con = false
      respond_to do |format|
        format.js { render 'settings/index' }
      end
    end

  end

  # def customtext
  #   @setting = Setting.find(1)
  #   if @setting.update(customtext_params)
  #     # Guest.joins(:event).where("events.status = true").update(guest_params)
  #     redirect_to settings_path, notice: 'Currency was successfuly edited.'
  #   end
  # end

  def reset
    #    guest = Guest.where(event_id: event_id)
    #    guest.update_all(:presence => false, :time_of_entry => nil,:souvenir => false, :time_of_get_souvenir => nil)

    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case type_event_id
    when "Concert"
    #concert
       guest = Concert.where(event_id: event_id)
       guest.update_all(:presence => false, :time_of_entry => nil,:ticket => false, :time_of_get_ticket => nil)
    when "Weddings"
    #gatherings
       guest = Guest.where(event_id: event_id)
       guest.update_all(:presence => false, :time_of_entry => nil,:souvenir => false, :time_of_get_souvenir => nil)
    when "Gatherings"
    #gatherings no.3
        guest = Gathering.where(event_id: event_id)
        guest.update_all(:presence => false, :time_of_entry => nil, :souvenir =>false, :time_of_get_souvenir => nil)
    when "Absensi"
        guest = Absensi.where(event_id: event_id)
        guest.update_all(:presence => false, :time_of_entry => nil, :souvenir =>false, :time_of_get_souvenir => nil)
        waktu = Log.where(event_id: event_id)
        waktu.update_all(:status => false)
    else "Moving"
        guest = Moving.where(event_id: event_id)
        guest.update_all(:presence => false, :presence2 => false, :presence3 => false, :presence4 => false, :presence5 => false, :presence6 => false, :presence7 => false, :presence8 => false, :presence9 => false, :presence10 => false, :souvenir =>false, :souvenir2 =>false, :souvenir3 =>false, :souvenir4 =>false,  :souvenir5 =>false, :souvenir6 =>false, :souvenir7 =>false, :souvenir8 =>false, :souvenir9 =>false, :souvenir10 =>false,)
        waktu = Logmoving.where(event_id: event_id)
        waktu.update_all(:status => false)
    end
#    redirect_to settings_path
    @con = true
    respond_to do |format|
      format.js { render 'settings/index' }
    end
    rescue
    @con = false
    respond_to do |format|
      format.js { render 'settings/index' }
      end
  end

  def resetundian
    #    guest = Guest.where(event_id: event_id)
    #    guest.update_all(:presence => false, :time_of_entry => nil,:souvenir => false, :time_of_get_souvenir => nil)

    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case type_event_id
    when "Concert"
    #concert
       guest = Concert.where(event_id: event_id)
       guest.update_all(:winner => false)
    when "Weddings"
    #gatherings
       guest = Guest.where(event_id: event_id)
       guest.update_all(:winner => false)
    #gatherings no.3
    when "Gatherings"
        guest = Gathering.where(event_id: event_id)
        guest.update_all(:winner => false)
    when "Absensi"
        guest = Absensi.where(event_id: event_id)
        guest.update_all(:winner => false)
    else "Moving"
        guest = Moving.where(event_id: event_id)
        guest.update_all(:winner => false)
    end
#    redirect_to settings_path
    @con = true
    respond_to do |format|
      format.js { render 'settings/index' }
    end
    rescue
    @con = false
    respond_to do |format|
      format.js { render 'settings/index' }
      end
  end

  def resetlogabsensi
        event_id = Event.find_by(status: true).id
        resetlogabsensi = Log.where(event_id: event_id)
        resetlogabsensi.delete_all
           @con = true
           respond_to do |format|
             format.js { render 'settings/index' }
           end
           rescue
           @con = false
           respond_to do |format|
             format.js { render 'settings/index' }
             end
  end

  def resetlogmoving
        event_id = Event.find_by(status: true).id
        resetlogmoving = Logmoving.where(event_id: event_id)
        resetlogmoving.delete_all
           @con = true
           respond_to do |format|
             format.js { render 'settings/index' }
           end
           rescue
           @con = false
           respond_to do |format|
             format.js { render 'settings/index' }
             end
  end

  def allpresence
    #    guest = Guest.where(event_id: event_id)
    #    guest.update_all(:presence => false, :time_of_entry => nil,:souvenir => false, :time_of_get_souvenir => nil)

    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case type_event_id
    when "Concert"
    #concert
       guest = Concert.where(event_id: event_id)
       guest.update_all(:presence => true)
    when "Weddings"
    #gatherings
       guest = Guest.where(event_id: event_id)
       guest.update_all(:presence => true)
    #gatherings no.3
    when "Gatherings"
        guest = Gathering.where(event_id: event_id)
        guest.update_all(:presence => true)
    else "Absensi"
        guest = Absensi.where(event_id: event_id)
        guest.update_all(:presence => true)
    end
#    redirect_to settings_path
    @con = true
    respond_to do |format|
      format.js { render 'settings/index' }
    end
    rescue
    @con = false
    respond_to do |format|
      format.js { render 'settings/index' }
      end
  end

  private

  def customtext_params
    params.require(:setting).permit(:custom_one_text,:custom_two_text,:custom_three_text,:custom_four_text,:custom_five_text,:jumlah_undangan)
  end

end

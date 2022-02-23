 class UndiansController < ApplicationController

  def index
    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    @type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case @type_event_id
    when "Weddings"
    @people = Guest.where(event_id: event_id)
                   .where(presence: 'TRUE')
                   .order("created_at DESC")
                   .all
      if @people.last != nil
         @lucky_person = @people.last
      end
    when "Concert"
    @people = Concert.where(event_id: event_id)
                     .where(kategori:'TIKET')
                     .order("created_at DESC")
                     .all
      if @people.last != nil
         @lucky_person = @people.last
      end
    when "Gatherings"
    @people = Gathering.where(event_id: event_id)
                       .order("created_at DESC")
                       .all
      if @people.last != nil
         @lucky_person = @people.last
      end
    when "Absensi"
    @people = Absensi.where(event_id: event_id)
                     .order("created_at DESC")
                     .all
      if @people.last != nil
         @lucky_person = @people.last
      end
    else "Moving"
    @people = Moving.where(event_id: event_id)
                       .order("created_at DESC")
                       .all
      if @people.last != nil
         @lucky_person = @people.last
      end
    end
  end

  def winner
    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    @type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case @type_event_id
    when "Weddings"
    @winners = Guest.where(event_id: event_id)
                    .where("presence != FALSE")
                    .where("winner != FALSE")
                    .all
                    .order("updated_at ASC")
    when "Concert"
    @winners = Concert.where(event_id: event_id)
                      .where(kategori: 'TIKET')
                      .where("ticket != FALSE")
                      .where("winner != FALSE")
                      .all
                      .order("updated_at ASC")
    when "Gatherings"
    @winners = Gathering.where(event_id: event_id)
                        .where("presence != FALSE")
                        .where("winner != FALSE")
                        .all
                        .order("updated_at ASC")
    when "Absensi"
    @winners = Absensi.where(event_id: event_id)
                      .where("presence != FALSE")
                      .where("winner != FALSE")
                      .all
                      .order("updated_at ASC")
    else "Moving"
    @winners = Moving.where(event_id: event_id)
                      .where("presence != FALSE OR presence2 != FALSE OR presence3 != FALSE OR presence4 != FALSE OR presence5 != FALSE OR presence6 != FALSE OR presence7 != FALSE OR presence8 != FALSE OR presence9 != FALSE OR presence10 != FALSE")
                      .where("winner != FALSE")
                      .all
                      .order("updated_at ASC")
    end
  end

  def thechoosen
    event_id = Event.find_by(status: true).id
    type_of_event_id = Event.where(id:event_id).first.type_of_event_id
    type_event_id = TypeOfEvent.joins(:events).where(id:type_of_event_id).first.name
    case type_event_id
    when "Weddings"
      @countall = Guest.where(event_id: event_id)
                     .where("presence != FALSE")
                     .where("winner != TRUE")
                     .where("kategori != 'SYSTEM'")
                     .count
      @lucky_person = Guest.where(event_id: event_id)
                     .where("presence != FALSE")
                     .where("winner != TRUE")
                    #  iki ganti
                    #  .where(guest_id:'ROD0023')
                     .all
                     .shuffle
                     .first
      if @countall != 0
      @winner = @lucky_person.update(winner: "TRUE")
        respond_to do |format|
          format.json { render :json => @lucky_person.to_json }
          format.js { render :json => @lucky_person.to_json }
          format.html { redirect_to root_path }
        end
      else
        @con == false
        respond_to do |format|
          format.js
        end
      end
    when "Concert"
      @countall = Concert.where(event_id: event_id)
                     .where("kategori != KWITANSI")
                     .where("ticket != FALSE")
                     .where("winner != TRUE")
                     .count
      @lucky_person = Concert.where(event_id: event_id)
                     .where(kategori: 'TIKET')
                     .where("ticket != FALSE")
                     .where("winner != TRUE")
                     .all
                     .shuffle
                     .first
      if @countall != 0
        @winner = @lucky_person.update(winner: "TRUE")
        respond_to do |format|
          format.json { render :json => @lucky_person.to_json }
          format.js { render :json => @lucky_person.to_json }
          format.html { redirect_to root_path }
        end
      else
        @con == false
        respond_to do |format|
          format.js
        end
      end
    when "Gatherings"
       @countall = Gathering.where(event_id: event_id)
                      .where("presence != FALSE")
                      .where("winner != TRUE")
                      .count
      @lucky_person = Gathering.where(event_id: event_id)
                     .where("presence != FALSE")
                     .where("winner != TRUE")
                     .all
                     .shuffle
                     .first
      if @countall != 0
        @winner = @lucky_person.update(winner: "TRUE")
        respond_to do |format|
          format.json { render :json => @lucky_person.to_json }
          format.js { render :json => @lucky_person.to_json }
          format.html { redirect_to root_path }
        end
      else
        @con == false
        respond_to do |format|
          format.js
        end
      end
    when "Absensi"
       @countall = Absensi.where(event_id: event_id)
                      .where("presence != FALSE")
                      .where("winner != TRUE")
                      .count
      @lucky_person = Absensi.where(event_id: event_id)
                     .where("presence != FALSE")
                     .where("winner != TRUE")
                     .all
                     .shuffle
                     .first
      if @countall != 0
        @winner = @lucky_person.update(winner: "TRUE")
        respond_to do |format|
          format.json { render :json => @lucky_person.to_json }
          format.js { render :json => @lucky_person.to_json }
          format.html { redirect_to root_path }
        end
      else
        @con == false
        respond_to do |format|
          format.js
        end
      end
    else "Moving"
       @countall = Moving.where(event_id: event_id)
                      .where("presence != FALSE OR presence2 != FALSE OR presence3 != FALSE OR presence4 != FALSE OR presence5 != FALSE OR presence6 != FALSE OR presence7 != FALSE OR presence8 != FALSE OR presence9 != FALSE OR presence10 != FALSE")
                      .where("winner != TRUE")
                      .count
      @lucky_person = Moving.where(event_id: event_id)
                      .where("presence != FALSE OR presence2 != FALSE OR presence3 != FALSE OR presence4 != FALSE OR presence5 != FALSE OR presence6 != FALSE OR presence7 != FALSE OR presence8 != FALSE OR presence9 != FALSE OR presence10 != FALSE")
                     .where("winner != TRUE")
                     .all
                     .shuffle
                     .first
      if @countall != 0
        @winner = @lucky_person.update(winner: "TRUE")
        respond_to do |format|
          format.json { render :json => @lucky_person.to_json }
          format.js { render :json => @lucky_person.to_json }
          format.html { redirect_to root_path }
        end
      else
        @con == false
        respond_to do |format|
          format.js
        end
      end
    end
  end

end

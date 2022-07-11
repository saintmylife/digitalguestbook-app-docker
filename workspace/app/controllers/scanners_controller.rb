class ScannersController < ApplicationController

  layout false
  def index
    @active_event = Event.joins(:type_of_event)
                    .where(status:true).first.name.to_s
    @active_event_type = TypeOfEvent.joins(:events)
                    .where("events.status":true)
                    .first.name.to_s
    @settingan = Setting.last
  end

  def checkin
    @active_event_type = TypeOfEvent.joins(:events)
                    .where("events.status":true)
                    .first.name.to_s
    @settingan = Setting.last
  end

  def checkout
    @active_event_type = TypeOfEvent.joins(:events)
                    .where("events.status":true)
                    .first.name.to_s
  end

  def testscan
    @active_event_type = TypeOfEvent.joins(:events)
    .where("events.status":true)
    .first.name.to_s
@settingan = Setting.last
  end
end

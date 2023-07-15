class ResetPresenceAndSouvenir
  include Sidekiq::Worker

  def perform(guest_id,type,events)
      case type
      when "Weddings"
            guest = Guest.where(guest_id: guest_id,event_id: events)
            guest.update(presence:false,time_of_entry:nil,souvenir:false,time_of_get_souvenir: false)
      when "Concerts"
            guest = Concert.where(guest_id: guest_id,event_id: events)
            guest.update(presence:false,time_of_entry:nil,ticket:false,time_of_get_ticket:nil)
      when "Gatherings"
            guest = Gathering.where(guest_id: guest_id,event_id: events)
            guest.update(presence:false,time_of_entry:nil,souvenir:false,time_of_get_souvenir: false)
      else  "Absensi"
            guest = Absensi.where(guest_id: guest_id,event_id: events)
            guest.update(presence:false,time_of_entry:nil,souvenir:false,time_of_get_souvenir: false)
      end
  end
  
end
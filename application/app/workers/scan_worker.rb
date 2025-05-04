class ScanWorker
  include Sidekiq::Worker

  def perform(guest_id,type)
    case type
    when "Weddings"
          guest = Guest.find(guest_id)
          guest.update(presence:true,time_of_entry:Time.now())
    when "Concerts"
          guest = Concert.where(guest_id: guest_id)
          guest.update(presence:true,time_of_entry:Time.now())
    when "Gatherings"
          guest = Gathering.where(guest_id: guest_id)
          guest.update(presence:true,time_of_entry:Time.now())
    when  "Absensi"
          guest = Absensi.where(guest_id: guest_id)
          guest.update(presence:true,time_of_entry:Time.now())
    else  "Moving"
            guest = Moving.where(guest_id: guest_id)
            guest.update(presence: true)
    end
#    guest = type.where(guest_id: guest_id)
#    guest.update(presence:true,time_of_entry:Time.now())
  end
end

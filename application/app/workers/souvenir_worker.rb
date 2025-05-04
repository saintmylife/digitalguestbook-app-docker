class SouvenirWorker
  include Sidekiq::Worker

  def perform(guest_id,type)
#     souvenir = Guest.where(guest_id: guest_id)
#     souvenir.update(souvenir:true,time_of_get_souvenir:Time.now())
    case type
    when "Weddings"
      souvenir = Guest.find(guest_id)
      souvenir.update(souvenir:true,time_of_get_souvenir:Time.now())
    when "Concerts"
      souvenir = Concert.where(guest_id: guest_id)
      souvenir.update(ticket:true,time_of_get_ticket:Time.now())
    when "Gatherings"
      guest = Gathering.where(guest_id: guest_id)
      guest.update(souvenir:true,time_of_get_souvenir:Time.now())
    when "Absensi"
      # "Absensi"
      guest = Absensi.where(guest_id: guest_id)
      guest.update(souvenir:true,time_of_get_souvenir:Time.now())
    else "Moving"
      # "Absensi"
      guest = Moving.where(guest_id: guest_id)
      guest.update(souvenir:true)
    end

  end
end

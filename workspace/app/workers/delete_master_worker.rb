class DeleteMasterWorker
  include Sidekiq::Worker

  def perform(id)
  	cek = Event.find(id)
    type = Event.find(id).type_of_event_id
    type2 = TypeOfEvent.find(type).name
    case type2
    when "Wedding"
          guest = Guest.where(event_id: cek)
          guest.delete_all
          cek.destroy
    when "Concerts"
      guest = Concert.where(event_id: cek)
      guest.delete_all
      cek.destroy
    when "Gatherings"
      guest = Gathering.where(event_id: cek)
      guest.delete_all
      cek.destroy
    when "Absensi"
      guest = Absensi.where(event_id: cek)
      guest.delete_all
      cek.destroy
    else
      guest = Moving.where(event_id: cek)
      guest.delete_all
      cek.destroy
    # Do something
  end
end
end

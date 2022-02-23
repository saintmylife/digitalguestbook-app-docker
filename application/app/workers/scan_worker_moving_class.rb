class ScanWorkerMovingClass
  include Sidekiq::Worker

  def perform(guest_id,classname)
    case classname
    when "Class01"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence: true)
    when "Class02"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence2: true)
    when "Class03"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence3: true)
    when "Class04"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence4: true)
    when "Class05"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence5: true)
    when "Class06"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence6: true)
    when "Class07"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence7: true)
    when "Class08"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence8: true)
    when "Class09"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence9: true)
    else "Class10"
        guest = Moving.where(guest_id: guest_id)
        guest.update(presence10: true)
    end
  end
end

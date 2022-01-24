class SouvenirWorkerMovingClass
  include Sidekiq::Worker

  def perform(guest_id,classname)
    case classname
    when "Class01"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir: true)
    when "Class02"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir2: true)
    when "Class03"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir3: true)
    when "Class04"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir4: true)
    when "Class05"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir5: true)
    when "Class06"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir6: true)
    when "Class07"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir7: true)
    when "Class08"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir8: true)
    when "Class09"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir9: true)
    else "Class10"
        guest = Moving.where(guest_id: guest_id)
        guest.update(souvenir10: true)
    end
  end
end

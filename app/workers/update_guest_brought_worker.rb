class UpdateGuestBroughtWorker
    include Sidekiq::Worker
  
      def perform(type,guest_code,guest_brought)
            if type.start_with?("Wedding")  
                  guest = Guest.where(guest_id: guest_code)
                  guest.update(jumlah_undangan: guest_brought)
            elsif type.start_with?("Gathering")
                  guest = Gathering.where(guest_id: guest_code)
                  guest.update(jumlah_orang: guest_brought)
            end
      end
  end
  
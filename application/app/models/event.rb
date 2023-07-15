class Event < ApplicationRecord
	belongs_to :type_of_event
	has_many :guests
	has_many :gatherings, dependent: :destroy
	has_many :concerts, dependent: :destroy
	has_many :guest_temporaries
	#has_many :log

	def self.search(name)
    name = name ? name.upcase : ""
    where("upper(name) ilike ?", "%#{name}%")
	end
end

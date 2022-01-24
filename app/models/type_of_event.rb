class TypeOfEvent < ApplicationRecord
	has_many :events
	def self.search(name)
		name = name ? name.upcase : ""
    	where("upper(name) ilike ?", "%#{name}%")
	end
end

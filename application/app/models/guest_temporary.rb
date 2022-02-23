class GuestTemporary < ApplicationRecord
	belongs_to :event

	def self.import(file,event_id)
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		  row = Hash[[header, spreadsheet.row(i)].transpose]
		  row["event_id"] = event_id
			row["no_undian"] = rand.to_s.slice(2,5)
			row["guest_id"] = generate_number(row["name"])
 		  guest = find_by_id(row["id"]) || new
		  guest.attributes = row.to_hash
		  guest.save!
		end
	end

	def self.generate_initial_name(name)
		split_name = name.split(" ")
		length = split_name.length
		intial_name = split_name[0].first
		1.upto(length-1) do |x|
			intial_name << split_name[x].first 
		end
		return intial_name
	end

  def self.generate_number(name)
    date = DateTime.now()
		get_partial = []
		get_partial[0] = date.day.to_s
		get_partial[1] = date.month.to_s
		get_partial[2] = date.year.to_s
		get_partial[3] = date.hour.to_s
		get_partial[4] = date.minute.to_s
		get_partial[5] = date.second.to_s

		structure_number = generate_initial_name(name).concat("_")

		get_partial.each do |x|
			structure_number.concat(x)
		end

    check_duplicate_id = GuestTemporary.where.not(guest_id:nil).where(guest_id: structure_number)

		if check_duplicate_id.present?
			return self.generate_number(name)
		else
			return structure_number
		end
  end
end

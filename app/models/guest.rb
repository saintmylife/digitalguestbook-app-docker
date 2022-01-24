class Guest < ApplicationRecord
	belongs_to :event

	validates_presence_of :guest_id, :event_id, :nama, presence: { message: "must be given please" }

	def self.search(name)
  	name = name ? name.upcase : ""
  	where("upper(nama) ilike ?", "%#{name}%")
	end

	def self.import(file,event_id)
		return false if file.blank? || event_id.blank?
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		  row = Hash[[header, spreadsheet.row(i)].transpose]
		  row["event_id"] = event_id
			guest = find_by_id(row["id"]) || new
		  guest.attributes = row.to_hash
		  #guest.no_undian = guest.guest_id[5,12]
			guest.no_undian = guest.guest_id
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
		get_partial[0] = date.hour.to_s
		get_partial[1] = date.minute.to_s
		get_partial[2] = date.second.to_s

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

	def self.search(search,check)
    if search
      case check
      #nama
      when "0"
          where (["nama ilike ?","%#{search}%"])
      #guest_id
      when "1"
          where (["guest_id ilike ?","%#{search}%"])
			when "2"
	         where (["alamat ilike ?","%#{search}%"])
			when "3"
	         where (["nama_meja ilike ?","%#{search}%"])
			when "4"
			 		 where (["kategori ilike ?","%#{search}%"])

      end
    end
  end

  def self.search_live(params)
	# where("concat_ws(guest_id, nama, kategori, alamat, nama_meja) ilike ?", "%#{params}%")
	where("concat_ws(guest_id, nama, kategori, alamat, nama_meja, custom_one_text, custom_two_text) ilike ?", "%#{params}%")
  end

end

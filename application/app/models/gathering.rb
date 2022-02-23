class Gathering < ApplicationRecord
	belongs_to :event

	validates_presence_of :guest_id, :event_id, :nama_peserta, presence: { message: "must be given please" }

	def self.search(search,check)
		if search
			case check
			#nama
			when "0"
					where (["nama_peserta ilike ?","%#{search}%"])
			#guest_id
			when "1"
					where (["guest_id ilike ?","%#{search}%"])
			when "2"
					where (["nip ilike ?","%#{search}%"])
			when "3"
					where (["instansi ilike ?","%#{search}%"])
			when "4"
					where (["category ilike ?","%#{search}%"])
			when "5"
					where (["unit_kerja ilike ?","%#{search}%"])
			else
					where (["jabatan ilike ?","%#{search}%"])
			end
		end
	end

  def self.import(file,event_id)
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		  row = Hash[[header, spreadsheet.row(i)].transpose]
		  row["event_id"] = event_id
			gathering = find_by_id(row["id"]) || new
		  gathering.attributes = row.to_hash
		  gathering.save!
		end
	end

	def name_with_initial
    "#{nama_peserta} / #{unit_kerja} / #{nip}"
	end

end

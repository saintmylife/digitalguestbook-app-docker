class Absensi < ApplicationRecord
  belongs_to :event


  validates_presence_of :guest_id, :event_id, :nama, presence: { message: "must be given please" }

  def self.import(file,event_id)
		return false if file.blank? || event_id.blank?
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		  row = Hash[[header, spreadsheet.row(i)].transpose]
		  row["event_id"] = event_id
			absensi = find_by_id(row["id"]) || new
		  absensi.attributes = row.to_hash
		  absensi.save!
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
          where (["instansi ilike ?","%#{search}%"])
      when "3"
          where (["jabatan ilike ?","%#{search}%"])
      else
          where (["unit_kerja ilike ?","%#{search}%"])

      end
    end
  end

end

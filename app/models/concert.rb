class Concert < ApplicationRecord
  belongs_to :event

  validates_presence_of :guest_id, :event_id, :nama, :kategori, presence: { message: "must be given please" }

  def self.import(file,event_id)
		return false if file.blank? || event_id.blank?
		spreadsheet = Roo::Spreadsheet.open(file.path)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		  row = Hash[[header, spreadsheet.row(i)].transpose]
		  row["event_id"] = event_id
			concert = find_by_id(row["id"]) || new
		  concert.attributes = row.to_hash
		  concert.save!
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
          where (["jenis_tiket ilike ?","%#{search}%"])
      when "3"
          where (["class_user ilike ?","%#{search}%"])
      else
          if where (["email ilike ?","%#{search}%"]) == nil
            if where (["no_ponsel ilike ?","%#{search}%"]) == nil
                where (["no_ktp ilike ?","%#{search}%"])
            else
                where (["no_ponsel ilike ?","%#{search}%"])
            end
          else
            where (["email ilike ?","%#{search}%"])
          end
      end
    end
  end

end

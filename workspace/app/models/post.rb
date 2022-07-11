class Post < ApplicationRecord
	validates_presence_of :guest_id, :image
  has_attached_file :image, path: :save_path
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def save_path
    # ":rails_root/public/images/#{event_type}/#{event_name}/:normalize_basename.:extension"
    ":rails_root/public/images/#{event_type}/#{event_name}/:normalize_basename:extension"
  end

  Paperclip.interpolates :normalize_basename do |attachment, style|
    attachment.instance.normalize_basename
  end

  def normalize_basename
    "#{guest_id}-:id.jpg"
  end

end

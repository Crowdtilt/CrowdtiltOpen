class AddAttachmentLogoImageToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :logo_image
    end
  end

  def self.down
    drop_attached_file :settings, :logo_image
  end
end

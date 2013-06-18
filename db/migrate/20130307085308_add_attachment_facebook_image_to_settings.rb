class AddAttachmentFacebookImageToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :facebook_image
    end
  end

  def self.down
    drop_attached_file :settings, :facebook_image
  end
end

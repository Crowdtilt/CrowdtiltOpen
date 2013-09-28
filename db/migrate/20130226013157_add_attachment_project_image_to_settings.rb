class AddAttachmentProjectImageToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :project_image
    end
  end

  def self.down
    drop_attached_file :settings, :project_image
  end
end

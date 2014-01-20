class AddAttachmentFaviconToCampaigns < ActiveRecord::Migration
  def self.up
    change_table :campaigns do |t|
      t.attachment :favicon
    end
  end

  def self.down
    drop_attached_file :campaigns, :favicon
  end
end

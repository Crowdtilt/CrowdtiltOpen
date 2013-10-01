class AddAttachmentVideoPlaceholderToSettings < ActiveRecord::Migration
  def change
    add_attachment :settings, :video_placeholder
  end
end
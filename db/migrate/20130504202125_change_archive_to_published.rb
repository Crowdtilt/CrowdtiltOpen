class ChangeArchiveToPublished < ActiveRecord::Migration
  def change
    rename_column :campaigns, :archive_flag, :published_flag
  end
end

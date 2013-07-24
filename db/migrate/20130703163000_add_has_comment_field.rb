class AddHasCommentField < ActiveRecord::Migration
  def change
    add_column :campaigns, :include_comments, :boolean, null: false, default: false
    add_column :campaigns, :comments_shortname, :string
  end
end

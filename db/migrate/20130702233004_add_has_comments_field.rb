class AddHasCommentsField < ActiveRecord::Migration
  def change
  	add_column :campaigns, :has_comments, :boolean, null: false, default: false
  	add_column :campaigns, :has_comments_label, :string
  end
end

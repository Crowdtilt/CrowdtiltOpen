class Changetwitterhandletostring < ActiveRecord::Migration
  def change
    change_column :bootcamps, :twitter_handle, :string
  end
end

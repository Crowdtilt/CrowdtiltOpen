class ChangeRaisedAmountToFloat < ActiveRecord::Migration
  def change
    change_column :campaigns, :stats_raised_amount, :float
  end
end

class AddGoalTypeToCampaigns < ActiveRecord::Migration
  def self.up 
    change_table :campaigns do |t|
      t.string   :goal_type, null: false, default: 'dollars'
      t.float    :goal_dollars, null: false, default: 1.0
      t.integer  :goal_orders, null: false, default: 1
      t.remove   :goal
    end
  end
  
  def self.down
    change_table :campaigns do |t|
      t.remove   :goal_type
      t.remove   :goal_dollars
      t.remove   :goal_orders
      t.float    :goal 
    end
  end

end

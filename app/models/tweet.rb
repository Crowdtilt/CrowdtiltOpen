class Tweet < ActiveRecord::Base
  attr_accessible :status
  belongs_to :bootcamp
end

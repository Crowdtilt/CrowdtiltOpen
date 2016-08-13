class ReferralCode < ActiveRecord::Base
  attr_accessible :code, :comment, :email

  def before_save
  	if(self.code.nil?)
  		self.code = ('0'..'9').to_a.concat(('A'..'Z').to_a).concat(('a'..'z').to_a).shuffle[0,8].join
  	end
  end
end

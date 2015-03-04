class AddDefaultValueToReferralCodeField < ActiveRecord::Migration
  def up
  	execute <<-SQL
		ALTER TABLE referral_codes ALTER COLUMN code SET DEFAULT random_string(7);
	SQL
  end

  def down
  	execute <<-SQL
		ALTER TABLE referral_codes ALTER COLUMN code SET DEFAULT NULL;
	SQL
  end
end

class AddReferralIdToUsers < ActiveRecord::Migration
  def up
	execute <<-SQL
		create or replace function random_string(length integer) returns text as 
		$$
		declare
		  chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
		  result text := '';
		  i integer := 0;
		begin
		  if length < 0 then
		    raise exception 'Given length cannot be less than 0';
		  end if;
		  for i in 1..length loop
		    result := result || chars[1+random()*(array_length(chars, 1)-1)];
		  end loop;
		  return result;
		end;
		$$ language plpgsql;
	SQL

	execute <<-SQL
		ALTER TABLE users ADD COLUMN referral_code TEXT DEFAULT random_string(7) UNIQUE;
	SQL

	add_column :users, :referred_by, :text
  end

  def down
  	remove_column :users, :referred_by
  	remove_column :users, :referral_code

  	execute <<-SQL
  		drop function random_string(length integer)
  	SQL
  end
end

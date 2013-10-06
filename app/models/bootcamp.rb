class Bootcamp < ActiveRecord::Base
  attr_accessible :name, :address, :city, :st_pr, :country, :contact_email, :website_url, :lat, :lon, :twitter_handle, :description


def full_location
  "#{address} #{city} #{st_pr}"
end

end


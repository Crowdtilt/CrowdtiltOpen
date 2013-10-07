require 'dstk'

namespace :data do
  desc "get latitude and longitude for all bootcamps that don't have it"
  task :geocoder => :environment do
    Geocoder.get_lat_lon
  end
end

class Geocoder


  def self.get_lat_lon
    dstk = DSTK::DSTK.new
    Bootcamp.all.each do |bootcamp|
    geocode=dstk.geocode(bootcamp.full_location)
    bootcamp.lat=geocode["results"].first["geometry"]["location"]["lat"]
    bootcamp.lon=geocode["results"].first["geometry"]["location"]["lng"]
    bootcamp.save!
    puts "#{bootcamp.name} set to #{bootcamp.lat} #{bootcamp.lon}\n"
    end
  end
end

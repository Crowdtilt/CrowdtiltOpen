#!/usr/bin/env ruby
# run as ruby purge.rb remote_name sandbox_key secret_key
# ex. heroku 12345 12345

remote_name = ARGV[0]
sandbox_key = ARGV[1]
secret_key = ARGV[2]

`#{remote_name} config:set CROWDTILT_SANDBOX_KEY=#{sandbox_key} CROWDTILT_SANDBOX_SECRET=#{secret_key}`

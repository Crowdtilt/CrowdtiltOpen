## Check for env file errors on startup. 
##
## We use .env.example as the definitions file for the necessary environment variables,
## and make sure that they're present in the rails environment on initialization.
## 
## If new values are added to .env.example, make sure that the correct number of lines 
## are being read in below. 

# Parse the first 13 lines of .env.example into a hash of the key value pairs
filename = File.join(Rails.root, ".env.example")
env_array = File.open(filename) { |f| (1..13).map { |x| f.readline.strip.split('=') } }

# remove asset sync b/c it doesn't make sense to check agains the default 'true'
env_hash = Hash[*env_array.flatten].except('ENABLE_ASSET_SYNC')

# If the user isn't using asset sync, we don't need to check other AWS vars
if ENV['ENABLE_ASSET_SYNC'] != 'true'
  env_hash = env_hash.except('AWS_BUCKET', 
                             'AWS_ACCESS_KEY_ID', 
                             'AWS_SECRET_ACCESS_KEY')
end

# Construct an array: [key, val, defined, default_value]
# defined (pair[2]) will be nil if the value is missing
# default_value (pair[3]) will be true if it's the same as in .env.example
# We'll only grab the arrays that have issues
incorrect_keys = env_hash.map do |key, val| 
                   [key, val, ENV[key], val == ENV[key]] 
                 end.select do |pair| 
                   pair[2].nil? || pair[3] 
                 end

unless incorrect_keys.empty?
  logger = Logger.new(STDOUT)
  # format is "FATAL: msg", we don't care about the other formatting options
  logger.formatter = proc { |s, _, _, m| "#{s}: #{m}\n" }
  incorrect_keys.map do |key, _, val|
    if val.nil?
      logger.send(:fatal, "Missing ENV var: #{key}")
    else # we've already filtered the array, so if it's not nil, it has to be invalid
      logger.send(:fatal, "Invalid ENV var: #{key}=#{val}")
    end
  end
  logger.fatal('Make sure you have set the vars in .env and are running this process with foreman')
  raise SystemExit, 1
end

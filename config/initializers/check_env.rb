## Check for env file errors on startup

# Only read the first 13 lines of the file into the array (in case the file has
# issues), then convert the array to a hash
filename = File.join(Rails.root, ".env.example")
env_array = File.open(filename) { |f| (1..13).map { |x| f.readline.strip.split('=') } }
# remove asset sync b/c checking against default value doesn't make sense here
env_hash = Hash[*env_array.flatten].except('ENABLE_ASSET_SYNC')

# If the user isn't using asset sync, we don't need to check AWS
if ENV['ENABLE_ASSET_SYNC'] != 'true'
  env_hash = env_hash.except('AWS_BUCKET', 
                             'AWS_ACCESS_KEY_ID', 
                             'AWS_SECRET_ACCESS_KEY')
end

# pair[2] will be nil if it's not defined, and pair[3] will be true if it's
# still the default value from the example file
incorrect_keys = env_hash.map do |key, val| 
                   [key, val, ENV[key], val == ENV[key]] 
                 end.select do |pair| 
                   pair[2].nil? || pair[3] 
                 end

unless incorrect_keys.empty?
  logger = Logger.new(STDOUT)
  # format is FATAL: msg, we don't care about the other formatting options
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

class Multisite::SessionsController < Devise::SessionsController
  layout 'multisite/multisite'
  skip_filter :check_initialized
end

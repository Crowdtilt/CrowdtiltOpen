class SessionsController < Devise::SessionsController
  skip_filter :check_initialized
end

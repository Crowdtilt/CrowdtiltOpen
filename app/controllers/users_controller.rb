class UsersController < BaseController
  before_filter :authenticate_user!
end

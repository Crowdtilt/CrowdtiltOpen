module Constraint

  class AdminRoute < Struct.new(:invert)
    def initialize(invert)
      @multisite_enabled = Rails.configuration.multisite_enabled
      @invert = invert
    end

    def matches?(request)
      return_value = nil
      if @multisite_enabled
        return_value = (request.subdomain == 'admin')
      else
        return_value = false
      end

      if @invert
        return return_value
      else
        return !return_value
      end
    end
  end

end

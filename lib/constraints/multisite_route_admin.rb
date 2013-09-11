module Constraint

  class MultisiteRouteAdmin < MultisiteRoute
    def matches?(request)
      if @multisite_enabled
        return request.subdomain == 'admin'
      else
        return false
      end
    end
  end

end

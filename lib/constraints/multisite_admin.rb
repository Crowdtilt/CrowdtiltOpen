module Constraint

  class MultisiteAdmin < Multisite
    def matches?(request)
      if @multisite_enabled
        return request.subdomain == 'admin'
      else
        return false
      end
    end
  end

end

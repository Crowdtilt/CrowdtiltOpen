module Constraint

  class MultisiteNonAdmin < Multisite
    def matches?(request)
      if @multisite_enabled
        return request.subdomain != 'admin'
      else
        return true
      end
    end
  end

end

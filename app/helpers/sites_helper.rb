module SitesHelper

  def custom_url(site)
    if site.custom_domain
      return root_url(:host => site.custom_domain)
    else
      return root_url(:host => @central_domain, :subdomain => site.subdomain)
    end
  end
end

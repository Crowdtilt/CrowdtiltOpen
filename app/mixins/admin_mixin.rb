module AdminMixin

  def create_breadcrumb(val)
    @breadcrumbs ||= []
    @breadcrumbs += [val]
  end

end

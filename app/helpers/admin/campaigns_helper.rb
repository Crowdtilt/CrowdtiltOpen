module Admin::CampaignsHelper

  def tabs_list_items(campaign)
    campaign.tabs.map do |tab|
      content_tag(:li, link_to(tab.title, "##{dom_id(tab)}"))
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    singular = association.to_s.singularize
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{singular}_fields", f: builder)
    end
    link_to(name, '#', class: "#{singular}-add", data: {id: id, fields: fields.gsub("\n", "")})
  end
end

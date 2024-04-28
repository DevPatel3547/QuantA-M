module ActivitiesHelper
  def view_button(view_type, current_view)
    active_class = view_type == current_view ? 'active' : ''
    icon = view_type == 'list' ? 'fa fa-list' : 'fa-regular fa-calendar'
    view_name = view_type.capitalize + ' View'

    link_to activities_path(view: view_type), class: "btn btn-secondary #{active_class}" do
      "<i class='#{icon}'></i> #{view_name}".html_safe
    end
  end
end

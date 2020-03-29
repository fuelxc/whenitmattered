module ApplicationHelper
  def google_maps_javascipt_tag
    javascript_include_tag("https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_API_KEY']}&libraries=places")
  end
end

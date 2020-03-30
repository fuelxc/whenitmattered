module ApplicationHelper
  def google_maps_javascipt_tag
    javascript_include_tag("https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_API_KEY']}&libraries=places")
  end

  def flash_class(level)
    case level
        when :notice, 'notice' then "alert-info"
        when :success, 'success' then "alert-success"
        when :error, 'error' then "alert-error"
        when :alert, 'alert' then "alert-error"
    end
  end
end

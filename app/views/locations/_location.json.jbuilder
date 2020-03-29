json.extract! location, :id, :name, :address, :notes
json.display_name [location.business.name, location.name].compact.join(' - ')
json.lat location.latlon&.lat
json.lon location.latlon&.lon
json.articles location.articles do |article|
  json.extract! article, :url, :headline
end
json.url location_url(location, format: :json)

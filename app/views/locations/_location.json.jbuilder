json.extract! location, :id, :business_id, :name, :address, :notes, :latlon, :created_at, :updated_at
json.url location_url(location, format: :json)

class Location < ApplicationRecord
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  belongs_to :business
  validates :address, presence: true

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  delegate :name, to: :business

  def self.nearby(latitude:, longitude:, distance: 5000)
    where("ST_DWithin(meetups.coords, ST_GeographyFromText('SRID=4326;POINT(:lon :lat)'), 
      :distance)", lon: longitude, lat: latitude, distance: distance)
  end

  def geography_hash
    return nil unless latlon
    {
      lat: latlon.latitude,
      lon: latlon.longitude
    }
  end

  def search_data
    {
      name: name,
      autocomplete_name: name,
      location: {
        lat: latitude,
        lon: longitude
      }
    }
  end

  def longitude
    latlon&.longitude
  end

  def latitude
    latlon&.latitude
  end
end

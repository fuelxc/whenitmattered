class Location < ApplicationRecord
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  belongs_to :business
  validates :address, presence: true

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.lat = geo.latitude
      obj.lon = geo.longitude
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_commit :reindex_business, if: ->(obj){ obj.address_changed? }

  delegate :articles, to: :business
  delegate :url, to: :business

  def nearby(latitude, longitude, distance_in_mile = 1)
    where(%{
     ST_Distance(clinic_lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  end

  def self.within(tl_lat:, tl_lon:, br_lat:, br_lon:)
    where(lat: (br_lat..tl_lat), lon: (tl_lon..br_lon))
  end

  def geography_hash
    return nil unless latlon
    {
      lat: latlon.latitude,
      lon: latlon.longitude
    }
  end

  def display_name
    [business.name, name].reject(&:blank?).join(' - ')
  end

  def search_data
    {
      name: name,
      autocomplete_name: display_name,
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

  private

  def reindex_business
    business.reindex
  end
end

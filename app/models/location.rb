class Location < ApplicationRecord
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  belongs_to :business
  validates :address, presence: true

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_commit :reindex_business, if: ->(obj){ obj.address_changed? }

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
      autocomplete_name: "#{business.name} - #{name}",
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

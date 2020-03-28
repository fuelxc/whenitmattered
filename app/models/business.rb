class Business < ApplicationRecord
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  has_many :articles, dependent: :destroy
  has_many :locations, dependent: :destroy

  accepts_nested_attributes_for :articles, allow_destroy: true
  accepts_nested_attributes_for :locations, allow_destroy: true

  validates :name, presence: true

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  def search_data
    {
      name: name,
      autocomplete_name: name,
      location: all_locations_geography
    }
  end

  private

  def all_locations_geography
    locations.collect(&:geography_hash).compact
  end
end

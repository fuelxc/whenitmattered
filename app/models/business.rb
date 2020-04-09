class Business < ApplicationRecord
  include ScraperConcern
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  belongs_to :category

  has_many :articles, dependent: :destroy
  has_many :locations, dependent: :destroy

  accepts_nested_attributes_for :articles, allow_destroy: true, reject_if: ->(attributes){ attributes['url'].blank? }
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: ->(attributes){ attributes['address'].blank? }

  validates :name, presence: true
  validates :notes, presence: { message: "or a linked article is required." }, if: ->(obj){ obj.articles.empty? }
  validates :online, inclusion: { in: [true], message: "or a location is required." }, if: ->(obj){ obj.locations.empty? }

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.lat = geo.latitude
      obj.lon = geo.longitude
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  before_save :scrape_opengraph, if: ->(obj){ obj.url_changed? }
  after_commit :clear_category_cache, if: ->(obj){ obj.category.changed? }
  after_commit :reindex_locations, if: ->(obj){ obj.name_changed? }

  def nearby(latitude, longitude, distance_in_mile = 1)
    where(%{
     ST_Distance(clinic_lonlat, 'POINT(%f %f)') < %d
    } % [longitude, latitude, distance_in_mile * 1609.34]) # approx
  end

  def self.within(tl_lat:, tl_lon:, br_lat:, br_lon:)
    where(lat: (br_lat..tl_lat), lon: (tl_lon..br_lon))
  end

  def search_data
    {
      name: name,
      autocomplete_name: name,
      location: all_locations_geography
    }
  end

  def image_url
    opengraph_data&.fetch("image", nil)
  end

  private

  def scrape_opengraph
    self.opengraph_data = scrape_data(url)
  end

  def all_locations_geography
    locations.collect(&:geography_hash).compact
  end

  def reindex_locations
    locations.map(&:reindex)
  end
  
  def clear_category_cache
    Rails.cache.delete(:category_options_array)
  end
end

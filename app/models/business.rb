class Business < ApplicationRecord
  include ScraperConcern
  searchkick word_start: [:autocomplete_name], suggest: [:name], locations: [:location]

  has_many :articles, dependent: :destroy
  has_many :locations, dependent: :destroy

  accepts_nested_attributes_for :articles, allow_destroy: true, reject_if: ->(attributes){ attributes['url'].blank? }
  accepts_nested_attributes_for :locations, allow_destroy: true, reject_if: ->(attributes){ attributes['address'].blank? }

  validates :name, presence: true
  validates :articles, presence: true
  validates :locations, presence: true

  before_save :scrape_opengraph, if: ->(obj){ obj.url_changed? }

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end

  before_save :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  after_commit :reindex_locations, if: ->(obj){ obj.name_changed? }

  def search_data
    {
      name: name,
      autocomplete_name: name,
      location: all_locations_geography
    }
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
end

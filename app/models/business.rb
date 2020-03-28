class Business < ApplicationRecord
  before_save :geocode
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
end

class Location < ApplicationRecord
  belongs_to :business
  validates :address, presence: true

  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end
end

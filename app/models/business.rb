class Business < ApplicationRecord
  before_save :geocode
  has_many :articles, dependent: :destroy
  has_many :locations, dependent: :destroy

  geocoded_by :address do |obj,results|
    if geo = results.first
      obj.latlon = "POINT(#{geo.longitude} #{geo.latitude})"
    end
  end
end

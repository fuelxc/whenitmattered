class Category < ApplicationRecord
  has_many :businesses

  validates :id, uniqueness: true

  before_save :clean_id
  after_commit :clear_cache

  def self.with_businesses
    joins(:businesses).distinct
  end

  def to_s
    display_name
  end

  private

  def clean_id
    attributes["id"] = attributes["id"].downcase.gsub(/[^a-z ]/, '').gsub(/\s+/,'-')
  end

  def clear_cache
    Rails.cache.delete(:category_options_array)
  end
end

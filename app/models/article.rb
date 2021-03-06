# frozen_string_literal: true

class Article < ApplicationRecord
  include ScraperConcern
  belongs_to :business

  validates :business, presence: true
  validates :url, presence: true

  before_create :scrape_opengraph

  def headline
    opengraph_data.fetch("description", nil)
  end

  private

  def scrape_opengraph
    self.opengraph_data = scrape_data(url)
    crawled_at = DateTime.now
  end
end

# frozen_string_literal: true

require 'faraday'
require 'ogp'

class Article < ApplicationRecord
  belongs_to :business

  validates :business, presence: true
  validates :url, presence: true

  before_create :scrape_opengraph

  def headline
    opengraph_data.fetch("description", nil)
  end

  private

  def scrape_opengraph
    response = Faraday.get(url)
    self.opengraph_data = OGP::OpenGraph.new(response.body)&.data
    crawled_at = DateTime.now
  end
end

module ScraperConcern
  def scrape_data(scraper_url)
    scrape_opengraph_data(scraper_url) || manual_data(scraper_url)
  end

  def scrape_opengraph_data(scraper_url)
    response = Faraday.get(scraper_url)
    OGP::OpenGraph.new(response.body)&.data rescue nil
  end
  
  def manual_data(scraper_url)

  end
end
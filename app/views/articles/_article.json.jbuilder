json.extract! article, :id, :url, :opengraph_data, :business_id, :crawled_at, :created_at, :updated_at
json.url article_url(article, format: :json)

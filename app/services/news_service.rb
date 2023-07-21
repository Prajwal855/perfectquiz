# app/services/news_service.rb
require 'httparty'

class NewsService
  def initialize
    @api_key = ENV['NEWS_API_KEY']
    @base_url = 'https://newsapi.org/v2/'
  end

  def get_top_headlines(options = {})
    endpoint = 'top-headlines'
    query_params = default_params.merge(options)
    make_api_request(endpoint, query_params)
  end

  def get_all_articles(options = {})
    endpoint = 'everything'
    query_params = default_params.merge(options)
    make_api_request(endpoint, query_params)
  end

  def get_sources(options = {})
    endpoint = 'sources'
    query_params = options.merge(apiKey: @api_key)
    make_api_request(endpoint, query_params)
  end

  private

  def default_params
    {
      q: 'bitcoin',
      language: 'en',
      apiKey: @api_key
    }
  end

  def make_api_request(endpoint, query_params)
    url = "#{@base_url}#{endpoint}"
    response = HTTParty.get(url, query: query_params)
    JSON.parse(response.body)
  end
end

class NewsController < ApplicationController
    # before_action :logged_in_user
    
    def top_headlines
      news_service = NewsService.new
      @articles = news_service.get_top_headlines(news_params.to_h)
      render json: @articles
    rescue StandardError => e
      Rails.logger.error("Error in NewsController#top_headlines: #{e.message}")
      render json: { error: "An error occurred while processing the request." }, status: :internal_server_error
    end
  
    def all_articles
      news_service = NewsService.new
      @articles = news_service.get_all_articles(news_params.to_h)
      render json: @articles
    rescue StandardError => e
      Rails.logger.error("Error in NewsController#all_articles: #{e.message}")
      render json: { error: "An error occurred while processing the request." }, status: :internal_server_error
    end
  
    def sources
      news_service = NewsService.new
      @sources = news_service.get_sources(news_params.to_h)
      render json: @sources
    rescue StandardError => e
      Rails.logger.error("Error in NewsController#sources: #{e.message}")
      render json: { error: "An error occurred while processing the request." }, status: :internal_server_error
    end
  
    private
  
    def news_params
      params.permit(:q, :sources, :category, :language, :country, :domains, :from, :to, :sortBy, :page)
    end
  end
  
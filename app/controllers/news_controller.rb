class NewsController < BaseController
    before_action :logged_in_user
    
    def top_headlines
      news_service = NewsService.new
      @articles = news_service.get_top_headlines(news_params.to_h)
      render json: @articles
    end
  
    def all_articles
      news_service = NewsService.new
      @articles = news_service.get_all_articles(news_params.to_h)
      render json: @articles
    end
  
    def sources
      news_service = NewsService.new
      @sources = news_service.get_sources(news_params.to_h)
      render json: @sources
    end
  
    private
  
    def news_params
      params.permit(:q, :sources, :category, :language, :country, :domains, :from, :to, :sortBy, :page)
    end
  end
  
Rails.application.routes.draw do
  # Devise routes for admin_users using ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Nested resources for rooms and messages
  resources :rooms do
    resources :messages
  end

  # Root route
  root 'pages#home'

  # SMS verification endpoint
  post 'users/sms_confirmation', to: 'accounts#sms_confirm'

  # Custom routes for news
  get '/top_headlines', to: 'news#top_headlines'
  get '/all_articles', to: 'news#all_articles'
  get '/sources', to: 'news#sources'

  # Resource routes for various entities
  resources :intrests, :categories, :qualifications, :academics, 
  :subcategories, :choices, :courses, :chapters, :studymaterials,
  :questions

  # Custom route for course search
  get 'search', to: 'courses#elastic_search'

  # Custom routes for questions
  get 'getquestion', to: 'questions#filtered_questions'
  post 'submitanswer', to: 'questions#submit_answers'

  # Devise routes for users with custom controllers
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
end

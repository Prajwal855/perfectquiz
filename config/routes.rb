Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

 # choices endpoint
  get "choices", to: "choices#index"
  get "choice/:id", to: "choices#show"
  post "choice", to: "choices#create"
  put "choice/:id", to: "choices#update"
  delete "choice/:id", to: "choices#destroy"




  # questions endpoint
  get "questions", to: "questions#index"
  get "getquestion", to: "questions#filtered_questions"
  get "question/:id", to: "questions#show"
  post "question", to: "questions#create"
  put "question/:id", to: "questions#update"
  delete "question/:id", to: "questions#destroy"
  post "submitanswer", to: "questions#submit_answers"



  # users endpoint
  get "users", to: "users#index"
  get "user/:id", to: "users#show"
  post "user", to: "users#create"
  put "user/:id", to: "users#update"
  delete "user/:id", to: "users#destroy"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }
end

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  
 # sms Verification Endponit
 post 'users/sms_confirmation', to: 'accounts#sms_confirm'

 # intrest endpoint
 get "intrests", to: "intrests#index"
 get "intrest/:id", to: "intrests#show"
 post "intrest", to: "intrests#create"
 put "intrest/:id", to: "intrests#update"
 delete "intrest/:id", to: "intrests#destroy"

  # qualifications endpoint
  get "qualifications", to: "qualifications#index"
  get "qualification/:id", to: "qualifications#show"
  post "qualification", to: "qualifications#create"
  put "qualification/:id", to: "qualifications#update"
  delete "qualification/:id", to: "qualifications#destroy"

 # academics endpoint
 get "academics", to: "academics#index"
 get "academic/:id", to: "academics#show"
 post "academic", to: "academics#create"
 put "academic/:id", to: "academics#update"
 delete "academic/:id", to: "academics#destroy"

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

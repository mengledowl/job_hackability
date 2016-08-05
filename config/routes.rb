Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#home'

  resources :job_listings
  resources :comments, except: [:new]

end

Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#home'

  resources :job_listings do
    resources :comments, except: [:new]
    resources :interviews do
      resources :comments, only: [:create]
    end
  end
end

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  
  #具名路由
  get '/signup', to: 'users#new'
 
  get '/help', to: 'static_pages#help' 
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  
  resources :users
  #控制器 action
  get '/login', to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :account_activations, only: [:edit]
  
  resources :password_resets, only: [:create, :new , :edit, :update]
end

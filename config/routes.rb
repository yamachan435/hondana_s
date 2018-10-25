Rails.application.routes.draw do

  get 'sessions/new'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'static_pages#index'
  get '/rental', to: 'static_pages#rental', as: 'rental'
  
  get '/books/search', to: 'books#search'
  get '/books/result', to: 'books#result'
  get '/books/find', to: 'books#find'
  get '/books/:id', to: 'books#show', as: 'book'
  #TODO: as節の必要性
  patch 'books/:id', to: 'books#update'

  resources :stocks, only: [:new, :create]

  get '/api/books', to: 'books#api_index'
  get '/api/books/:id', to: 'books#api_show'
  post '/api/books', to: 'books#api_create'
  get '/api/books/isbn/:isbn', to: 'books#api_isbn'
  post '/api/books/borrow', to: 'books#api_borrow'
  post '/api/books/return', to: 'books#api_return'
  get '/api/books/search/:field/:q', to: 'books#api_search'
  get '/api/books/list/:user', to: 'books#list'

  #ImageAPI

  get 'images/:id' => 'images#show'
  post 'images' => 'images#create'
  get 'images/:id/download' => 'images#download'
  put 'images/:id/upload' => 'images#upload'
  get '/api/images/:isbn' => "images#api_isbn"

end

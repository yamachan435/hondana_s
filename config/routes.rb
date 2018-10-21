Rails.application.routes.draw do
  resources :book_infos
  resources :books

  get '/api/books', to: 'books#api_index'
  get '/api/books/:id', to: 'books#api_show'
  post '/api/books', to: 'books#api_create'
  #patch '/api/books/:id', to: 'books#update'
  #put '/api/books/:id', to: 'books#update'
  #delete '/api/books/:id', to: 'books#destroy'
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

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
   post '/users', to: 'users#create'

  # SESSIONS
  post '/sessions', to: 'sessions#create'
  get '/authenticated', to: 'sessions#authenticated'
  delete '/sessions', to: 'sessions#destroy'

  # TWEETS
  post '/tweets', to: 'tweets#create'
  delete '/tweets/:id', to: 'tweets#destroy'
  get '/tweets', to: 'tweets#index'
  get '/users/:username/tweets', to: 'tweets#index_by_user'

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end

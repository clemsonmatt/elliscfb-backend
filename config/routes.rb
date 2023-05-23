Rails.application.routes.draw do
  resources :games, only: [:show]
  resources :weeks, only: [] do
    collection do
      get '/:id/games', action: :games
    end
  end
  resources :seasons, only: [] do
    collection do
      get '/active-weeks', action: :active_weeks
    end
  end
  resources :teams, only: [] do
    collection do
      get '/:slug', action: :show
      get '/:slug/games', action: :games
    end
  end
  resources :conferences
  resources :users
  post '/login', to: 'sessions#login'
end

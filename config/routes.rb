Rails.application.routes.draw do
  resources :games, only: [:show, :create, :update] do
    collection do
      get '/:id/week', action: :week
      get '/:id/import', action: :import
    end
  end
  resources :game_stats, only: [:create, :update], path: '/game-stats' do
    collection do
      get '/:id/week', action: :week
    end
  end
  resources :weeks, only: [] do
    collection do
      get '/full-season', action: :full_season
    end
  end
  resources :seasons, only: [] do
    collection do
      get '/active-weeks', action: :active_weeks
    end
  end
  resources :teams, only: [:index] do
    collection do
      get '/:slug', action: :show
      get '/:slug/games', action: :games
    end
  end
  resources :conferences
  resources :users, only: [:create] do
    collection do
      get '/details', action: :details
    end
  end
  post '/login', to: 'sessions#login'
end

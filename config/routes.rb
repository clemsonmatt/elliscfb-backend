Rails.application.routes.draw do
  resources :games, only: [:show, :create, :update] do
    collection do
      get '/:id/week', action: :week
      get '/:id/import', action: :import
      post '/:id/toggle-pickem', action: :toggle_pickem
    end
  end
  resources :game_stats, only: [:create, :update], path: '/game-stats' do
    collection do
      get '/:id/week', action: :week
      get '/:id/import', action: :import
    end
  end
  resources :weeks, only: [] do
    collection do
      get '/full-season', action: :full_season
      get '/pickem-available', action: :pickem_available
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
      get '/:slug/next-game', action: :next_game
    end
  end
  resources :conferences
  resources :users, only: [:create, :update] do
    collection do
      get '/details', action: :details
    end
  end
  resources :pickem, only: [] do
    collection do
      get '/:id/week-games', action: :week_games
      get '/:id/week-picks', action: :week_picks
      get '/:id/week-picks-all', action: :week_picks_all
      post '/game-winner', action: :game_winner
      get '/stats', action: :stats
      get '/leaderboard', action: :leaderboard
      get '/show-time', action: :show_time
    end
  end

  scope as: :manage, module: :manage do
    resource :email, only: [] do
      get '/send-weekly-reminder', action: :send_weekly_reminder
    end
  end

  post '/login', to: 'sessions#login'
end

class Team < ApplicationRecord
  belongs_to :conference
  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :won_games, class_name: 'Game', foreign_key: 'winning_team_id'
  has_many :predicted_winning_games, class_name: 'Game', foreign_key: 'predicted_winning_team_id'

  def games
    games = home_games + away_games
    games.sort_by(&:date)
  end
end

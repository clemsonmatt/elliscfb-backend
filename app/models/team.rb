class Team < ApplicationRecord
  belongs_to :conference
  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :won_games, class_name: 'Game', foreign_key: 'winning_team_id'
  has_many :predicted_winning_games, class_name: 'Game', foreign_key: 'predicted_winning_team_id'
  has_many :rankings

  def games
    games = home_games + away_games
    games.sort_by(&:date)
  end

  def name
    return "#{ranking}. #{self[:name]}" unless ranking.nil?

    self[:name]
  end

  def name_short
    return "#{ranking}. #{self[:name_short]}" unless ranking.nil?

    self[:name_short]
  end

  def ranking
    current_week = Week.current_week.first

    return nil if current_week.nil?

    current_ranking = nil
    rankings.each do |ranking|
      current_ranking = ranking.rank if ranking.poll == 'AP Top 25' and ranking.week == current_week
      current_ranking = ranking.rank if ranking.poll == 'College Football Playoff' and ranking.week == current_week
    end

    return nil if current_ranking.nil?

    current_ranking
  end
end

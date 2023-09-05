class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winning_team_id', optional: true
  belongs_to :predicted_winning_team, class_name: 'Team', foreign_key: 'predicted_winning_team_id', optional: true

  has_many :game_stats

  scope :ordered_by_time, -> { order(date: :asc).order(Arel.sql("TO_TIMESTAMP(time, 'hh:mi AM')")).order(cfbd_game_id: :asc) }

  def week
    Week.find_by("start_date < ? AND end_date >= ?", date, date)
  end

  def home_team_stats
    game_stats.each do |stat|
      return stat if stat.team == home_team
    end

    nil
  end

  def away_team_stats
    game_stats.each do |stat|
      return stat if stat.team == away_team
    end

    nil
  end

  def datetime
    Time.find_zone('Eastern Time (US & Canada)').parse("#{date} #{time}").to_datetime
  end
end

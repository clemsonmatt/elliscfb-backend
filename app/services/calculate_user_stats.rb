class CalculateUserStats < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    # get the current season
    season = Season.find_by(active: true)
    season_start = Date.parse("#{season.year}-08-01")
    season_end = Date.parse("#{season.year+1}-01-31")

    # get all games that are pickems and complete
    games = Game.where(pickem: true).where('winning_team_id IS NOT NULL').where('date > ? AND date < ?', season_start, season_end).count

    # wins
    wins = Pickem.where(user: @user).joins(:game).where("games.winning_team_id = pickems.team_id").where('games.date > ? AND games.date < ?', season_start, season_end).count
    # losses
    losses = Pickem.where(user: @user).joins(:game).where("games.winning_team_id IS NOT NULL AND games.winning_team_id != pickems.team_id").where('games.date > ? AND games.date < ?', season_start, season_end).count
    # misses
    misses = games - (wins + losses)

    percentage = 0
    score = 0

    if wins + losses > 0
      # calculate percentage
      raw_percentage = wins.to_f / (wins + losses).to_f
      percentage = (raw_percentage * 100).round(1)

      # calculate points
      score = (5 * (wins * raw_percentage / 5).round(2) * 10).round(1)
    end

    {
      wins:,
      losses:,
      misses:,
      percentage:,
      score:
    }
  end
end

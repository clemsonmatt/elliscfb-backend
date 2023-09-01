class CalculateUserStats < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    # get all games that are pickems and complete
    games = Game.where(pickem: true).where('winning_team_id IS NOT NULL').count

    # wins
    wins = Pickem.where(user: @user).joins(:game).where("games.winning_team_id = pickems.team_id").count
    # losses
    losses = Pickem.where(user: @user).joins(:game).where("games.winning_team_id != pickems.team_id AND games.winning_team_id IS NOT NULL").count
    # misses
    misses = games - (wins + losses)

    # calculate percentage
    raw_percentage = wins.to_f / games.to_f
    percentage = (raw_percentage * 100).round(1)

    # calculate points
    score = 5 * (wins * raw_percentage / 5).round(2) * 10

    {
      games:,
      wins:,
      losses:,
      misses:,
      percentage:,
      score:
    }
  end
end

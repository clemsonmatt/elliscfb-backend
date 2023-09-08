class TeamsController < ApplicationController
  def index
    teams = Team.order(name: :asc)

    render json: teams
  end

  def show
    team = Team.find_by(slug: params[:slug])

    render json: team
  end

  def games
    team = Team.find_by(slug: params[:slug])
    games = team_games(team)

    render json: {
      team: team,
      games: JSON.parse(games.to_json(include: [:home_team, :away_team, :winning_team, :predicted_winning_team], methods: [:datetime, :home_team_stats, :away_team_stats]))
    }
  end

  def next_game
    team = Team.find_by(slug: params[:slug])

    next_game = nil

    games = team_games(team)
    games.each do |game|
      if game.date >= Date.today
        next_game = game
        break
      end
    end

    render json: nil if next_game.nil?

    render json: next_game.to_json(include: [:home_team, :away_team, :predicted_winning_team], methods: :datetime)
  end

  private

  def team_games(team)
    season = Season.find_by(active: true)
    week = Week.where(season: season, number: 1).first

    Game.where("home_team_id = ? OR away_team_id = ?", team.id, team.id).where("date >= ?", week.start_date).order(date: :asc)
  end
end

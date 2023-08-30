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
      games: JSON.parse(games.to_json(include: [:home_team, :away_team], methods: :datetime))
    }
  end

  def next_game
    team = Team.find_by(slug: params[:slug])
    game = team_games(team).first

    render json: game.to_json(include: [:home_team, :away_team], methods: :datetime)
  end

  private

  def team_games(team)
    Game.where("home_team_id = ? OR away_team_id = ?", team.id, team.id).where("date >= ?", Date.today).order(date: :asc)
  end
end

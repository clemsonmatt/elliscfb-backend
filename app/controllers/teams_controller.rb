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

    render json: {
      team: team,
      games: JSON.parse(team.games.to_json(include: { home_team: { only: :name_short }, away_team: { only: :name_short } }))
    }
  end
end

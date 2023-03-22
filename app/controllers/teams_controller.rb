class TeamsController < ApplicationController
  def show
    team = Team.find_by(slug: params[:slug])

    render json: team
  end

  def games
    team = Team.find_by(slug: params[:slug])

    render json: team.games
  end
end

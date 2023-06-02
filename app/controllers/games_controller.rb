class GamesController < ApplicationController
  def week
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])
    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date)

    render json: games.to_json(include: [:home_team, :away_team, :winning_team])
  end

  def show
    game = Game.find(params[:id])

    render json: game
  end
end

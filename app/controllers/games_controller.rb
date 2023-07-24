class GamesController < ApplicationController
  def week
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])
    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date)

    render json: games.to_json(include: [:home_team, :away_team, :winning_team])
  end

  def show
    game = Game.find(params[:id])

    render json: game.to_json(include: [:home_team, :away_team, :winning_team])
  end

  def create
    home_team = Team.find_by(slug: params[:home_team])
    away_team = Team.find_by(slug: params[:away_team])
    predicted_winner = Team.find_by(slug: params[:predicted_winner])

    game = Game.create!(
      date: Date.parse(params[:date]),
      home_team: home_team,
      away_team: away_team,
      time: params[:time],
      location: params[:location],
      spread: params[:spread],
      predicted_winning_team: predicted_winner,
      conference_championship: params[:conference_championship] == 'yes',
      bowl_name: params[:bowl_name]
    )

    render json: game.to_json(include: [:home_team, :away_team, :winning_team])
  end
end

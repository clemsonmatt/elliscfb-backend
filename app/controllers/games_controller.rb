class GamesController < ApplicationController
  before_action :is_admin, only: [:create, :update, :import]

  def week
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])
    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date).ordered_by_time

    render json: games.to_json(include: [:home_team, :away_team, :winning_team, :predicted_winning_team], methods: [:datetime, :away_team_stats, :home_team_stats])
  end

  def show
    game = Game.find(params[:id])

    render json: game.to_json(include: [:home_team, :away_team, :winning_team, :predicted_winning_team, :home_team_stats, :away_team_stats, :week], methods: :datetime)
  end

  def import
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])

    begin
      ImportWeekGames.call(week)
      ImportGameLines.call(week)
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date).ordered_by_time

    render json: games.to_json(include: [:home_team, :away_team, :winning_team, :predicted_winning_team])
  end

  def create
    home_team = Team.find_by(slug: params[:home_team])
    away_team = Team.find_by(slug: params[:away_team])
    predicted_winning_team = Team.find_by(slug: params[:predicted_winning_team])

    begin
      game = Game.create!(
        date: Date.parse(params[:date]),
        home_team: home_team,
        away_team: away_team,
        time: params[:time],
        location: params[:location],
        spread: params[:spread],
        predicted_winning_team: predicted_winning_team,
        conference_championship: params[:conference_championship] == 'yes',
        bowl_name: params[:bowl_name]
      )
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    render json: game.to_json(include: [:home_team, :away_team, :predicted_winning_team])
  end

  def update
    begin
      home_team = Team.find_by(slug: params[:home_team])
      away_team = Team.find_by(slug: params[:away_team])
      predicted_winning_team = Team.find_by(slug: params[:predicted_winning_team])

      game = Game.find(params[:id])
      game.update!(
        date: Date.parse(params[:date]),
        home_team: home_team,
        away_team: away_team,
        time: params[:time],
        location: params[:location],
        spread: params[:spread],
        predicted_winning_team: predicted_winning_team,
        conference_championship: params[:conference_championship] == 'yes',
        canceled: params[:canceled] == 'yes',
        bowl_name: params[:bowl_name]
      )
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    render json: game.to_json(include: [:home_team, :away_team, :predicted_winning_team])
  end

  def toggle_pickem
    game = Game.find(params[:id])

    if game.update(pickem: params[:pickem])
      render json: game.to_json(include: [:home_team, :away_team, :predicted_winning_team])
    else
      render json: { error: exception }, status: 500
    end
  end
end

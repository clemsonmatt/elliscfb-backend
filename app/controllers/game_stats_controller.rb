class GameStatsController < ApplicationController
  before_action :is_admin

  def week
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])
    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date).where("winning_team_id IS NULL").ordered_by_time

    render json: games.to_json(include: [:home_team, :away_team, :winning_team])
  end

  def import
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])

    begin
      ImportWeekGameStats.call(week)
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    games = Game.where("date > ? AND date < ?", week.start_date, week.end_date).where("winning_team_id IS NULL").ordered_by_time

    render json: games.to_json(include: [:home_team, :away_team, :winning_team])
  end

  def create
    game = Game.find(params[:game_id])

    # update if game already has stats
    home_stat = GameStat.find_by(game: game, team: game.home_team)
    return update_stats(game, params) unless home_stat.nil?

    begin
      home_stat = GameStat.create!(
        game: game,
        team: game.home_team,
        final: params[:home_final],
        q1: params[:home_q1],
        q2: params[:home_q2],
        q3: params[:home_q3],
        q4: params[:home_q4],
        ot: params[:home_ot],
        rushing_yards: params[:home_rushing_yards],
        rushing_attempts: params[:home_rushing_attempts],
        passing_yards: params[:home_passing_yards],
        passing_attempts: params[:home_passing_attempts],
        passing_completions: params[:home_passing_completions],
        turnovers: params[:home_turnovers],
        penalty_yards: params[:home_penalty_yards]
      )

      away_stat = GameStat.create!(
        game: game,
        team: game.away_team,
        final: params[:away_final],
        q1: params[:away_q1],
        q2: params[:away_q2],
        q3: params[:away_q3],
        q4: params[:away_q4],
        ot: params[:away_ot],
        rushing_yards: params[:away_rushing_yards],
        rushing_attempts: params[:away_rushing_attempts],
        passing_yards: params[:away_passing_yards],
        passing_attempts: params[:away_passing_attempts],
        passing_completions: params[:away_passing_completions],
        turnovers: params[:away_turnovers],
        penalty_yards: params[:away_penalty_yards]
      )

      # update game's winning team
      winning_team = game.home_team
      winning_team = game.away_team if away_stat.final > home_stat.final
      game.update(winning_team: winning_team)
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    render json: game.to_json(include: [:home_team, :away_team, :winning_team, :game_stats])
  end

  private

  def update_stats(game, params)
    begin
      home_stat = GameStat.find_by(game: game, team: game.home_team)
      home_stat.update(
        final: params[:home_final],
        q1: params[:home_q1],
        q2: params[:home_q2],
        q3: params[:home_q3],
        q4: params[:home_q4],
        ot: params[:home_ot],
        rushing_yards: params[:home_rushing_yards],
        rushing_attempts: params[:home_rushing_attempts],
        passing_yards: params[:home_passing_yards],
        passing_attempts: params[:home_passing_attempts],
        passing_completions: params[:home_passing_completions],
        turnovers: params[:home_turnovers],
        penalty_yards: params[:home_penalty_yards]
      )

      away_stat = GameStat.find_by(game: game, team: game.away_team)
      away_stat.update(
        final: params[:away_final],
        q1: params[:away_q1],
        q2: params[:away_q2],
        q3: params[:away_q3],
        q4: params[:away_q4],
        ot: params[:away_ot],
        rushing_yards: params[:away_rushing_yards],
        rushing_attempts: params[:away_rushing_attempts],
        passing_yards: params[:away_passing_yards],
        passing_attempts: params[:away_passing_attempts],
        passing_completions: params[:away_passing_completions],
        turnovers: params[:away_turnovers],
        penalty_yards: params[:away_penalty_yards]
      )

      # update game's winning team
      winning_team = game.home_team
      winning_team = game.away_team if away_stat.final > home_stat.final
      game.update(winning_team: winning_team)
    rescue => exception
      return render json: { error: exception }, status: 500
    end

    render json: game.to_json(include: [:home_team, :away_team, :winning_team, :game_stats])
  end
end

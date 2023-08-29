class PickemController < ApplicationController
  def week_games
    games = games_for_week(params[:id])

    render json: games.to_json(include: [:home_team, :away_team, :winning_team, :predicted_winning_team], methods: :datetime)
  end

  def week_picks
    picks = week_picks_for_user(params[:id])

    render json: { picks: picks.to_json }
  end

  def week_picks_all
    users_picks = week_picks_for_all_users(params[:id])

    render json: { user_picks: users_picks }
  end

  def game_winner
    game = Game.find(params[:game])
    team = Team.find(params[:team])

    # make sure valid game and team
    if game.nil? or team.nil?
      return render json: { error: 'Invalid game or team' }, status: 500
    end

    # make sure the game is unlocked
    unless active_games.include?(game)
      return render json: { error: 'Game not available for pickem' }, status: 500
    end

    # make sure user's winning team is playing that game
    if game.home_team != team and game.away_team != team
      return render json: { error: 'Invalid team for game' }, status: 500
    end

    # see if they already have picked this game
    pick = Pickem.find_by(user: @current_user, game:)

    if pick.nil?
      # record their prediction
      Pickem.create(user: @current_user, game:, team:)
    else
      pick.update(team:)
    end

    picks = week_picks_for_user(params[:week])

    render json: { picks: picks.to_json }
  end

  private

  def week_picks_for_user(week_number)
    games = games_for_week(week_number)
    game_ids = games.map { |game| game.id }

    pickems = Pickem.where(game: game_ids).where(user: @current_user)
    picks = pickems.map(&:team)
    picks.map!(&:slug)
  end

  def week_picks_for_all_users(week_number)
    games = games_for_week(week_number)
    game_ids = games.map { |game| game.id }

    pickems = Pickem.where(game: game_ids)
    users = pickems.map(&:user).uniq

    user_pickems = []
    users.each do |user|
      user_picks = Pickem.where(game: game_ids).where(user:)
      user_picks = user_picks.map(&:team)
      user_picks.map!(&:slug)

      user_pickems.push({
        username: user.username,
        picks: user_picks
      })
    end

    user_pickems
  end

  def games_for_week(week_number)
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: week_number)

    Game.where("date > ? AND date < ?", week.start_date, week.end_date).where(pickem: true).ordered_by_time
  end

  def active_games
    season = Season.where(active: true).first
    week = Week.where(season: season).where("start_date <= ? AND end_date >= ?", Date.today, Date.today).first

    games = games_for_week(week.number)

    games.map do |game|
      game if game.datetime >= Time.find_zone('Eastern Time (US & Canada)').now
    end

  end
end

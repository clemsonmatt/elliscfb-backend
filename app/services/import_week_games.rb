class ImportWeekGames < ApplicationService
  def initialize(week)
    @week = week
    @conn = ImportConnection.call()
  end

  def call
    begin
      # week 16 = bowls
      if @week.number == 16
        response = @conn.get('games', { year: @week.season.year, seasonType: 'postseason', division: 'fbs' })
      else
        response = @conn.get('games', { year: @week.season.year, week: @week.number, division: 'fbs' })
      end
    rescue Faraday::Error => e
      puts '+++++++++++++++++++'
      puts e.response[:status]
      puts e.response[:body]
      puts '+++++++++++++++++++'
    end

    games = response.body

    errors = []

    # loop over and add games
    games.each do |game|
      begin
        home_team = Team.find_by(name_short: game['home_team'])
        away_team = Team.find_by(name_short: game['away_team'])
        bowl_name = game['notes'] if game['season_type'] != 'regular'

        date = Time.find_zone('Eastern Time (US & Canada)').parse(game['start_date']).to_datetime
        time = date.to_time.strftime('%I:%M %p') unless game['start_time_tbd']

        cfbd_game_id = game['id']

        details = {
          home_team:,
          away_team:,
          date:,
          time:,
          location: game['venue'],
          bowl_name:,
          cfbd_game_id:
        }

        # see if game is already created
        created_game = Game.find_by(cfbd_game_id:)
        if created_game.nil?
          Game.create!(details)
        else
          created_game.update(details)
        end
      rescue => exception
        errors.push game.to_json
      end
    end

    if errors.length
      puts '==========ERRORS==========='
      errors.each do |error|
        puts error
      end
      puts '==========================='
    end
  end
end

class ImportWeekGameStats < ApplicationService
  def initialize(week)
    @week = week
    @conn = ImportConnection.call()
  end

  def call
    begin
      response = @conn.get('games', { year: @week.season.year, week: @week.number, division: 'fbs' })
    rescue Faraday::Error => e
      puts '+++++++++++++++++++'
      puts e.response[:status]
      puts e.response[:body]
      puts '+++++++++++++++++++'
    end

    games = response.body

    errors = []

    # loop over and update games
    games.each do |game|
      # only interested if the game is over
      next unless game['completed']

      begin
        created_game = Game.find_by(cfbd_game_id: game['id'])
        next if created_game.nil?

        # add home stats
        if created_game.home_team_stats.nil?
          quarter_scores = game['home_line_scores']

          home_stat = GameStat.create!(
            game: created_game,
            team: created_game.home_team,
            final: game['home_points'],
            q1: quarter_scores.shift
            q2: quarter_scores.shift
            q3: quarter_scores.shift
            q4: quarter_scores.shift
            ot: nil
          )

          # check for ot score
          total = home_stat.q1 + home_stat.q2 + home_stat.q3 + home_stat.q4
          home_stat.update(ot: final - total) unless final == total
        end

        # add away stats
        if created_game.away_team_stats.nil?
          quarter_scores = game['away_line_scores']

          away_stat = GameStat.create!(
            game: created_game,
            team: created_game.away_team,
            final: game['away_points'],
            q1: quarter_scores.shift
            q2: quarter_scores.shift
            q3: quarter_scores.shift
            q4: quarter_scores.shift
            ot: nil
          )

          # check for ot score
          total = away_stat.q1 + away_stat.q2 + away_stat.q3 + away_stat.q4
          away_stat.update(ot: final - total) unless final == total
        end

        # update winning team on game
        winning_team = home_team
        winning_team = away_team if away_stat.final > home_stat.final
        created_game.update(winning_team:)
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

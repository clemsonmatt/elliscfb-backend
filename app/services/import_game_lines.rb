class ImportGameLines < ApplicationService
  def initialize(week)
    @week = week
    @conn = ImportConnection.call()
  end

  def call
    begin
      # week 16 = bowls
      if @week.number == 16
        response = @conn.get('lines', { year: @week.season.year, seasonType: 'postseason' })
      else
        response = @conn.get('lines', { year: @week.season.year, week: @week.number })
      end
    rescue Faraday::Error => e
      puts '+++++++++++++++++++'
      puts e.response[:status]
      puts e.response[:body]
      puts '+++++++++++++++++++'
    end

    game_lines = response.body

    errors = []

    # loop over and update games
    game_lines.each do |game_line|
      begin
        # find game
        created_game = Game.find_by(cfbd_game_id: game_line['id'])
        next if created_game.nil?

        # see if there are any lines available
        next if game_line['lines'].empty?

        # add spread
        # home is predicted winner if spread has a "-"
        # away is predicted winner unless spread has a "-"
        spread = game_line['lines'][0]['spread']
        predicted_winning_team = created_game.away_team

        if spread.include?('-')
          predicted_winning_team = created_game.home_team
          spread = spread.sub('-', '')
        end

        created_game.update(predicted_winning_team:, spread:)
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

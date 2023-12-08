class ImportRankings < ApplicationService
  def initialize(week)
    @week = week
    @conn = ImportConnection.call()
  end

  def call
    begin
      # week 16 = bowls
      if @week.number == 16
        response = @conn.get('rankings', { year: @week.season.year, seasonType: 'postseason' })
      else
        response = @conn.get('rankings', { year: @week.season.year, week: @week.number })
      end
    rescue Faraday::Error => e
      puts '+++++RANKINGS+++++'
      puts e.response[:status]
      puts e.response[:body]
      puts '++++++++++++++++++'
    end

    # make sure we have a response (we might not if poll for week is not set yet)
    return false if response.body.empty?

    # delete any old rankings and we will replace them
    Ranking.where(week: @week).destroy_all

    polls = response.body[0]['polls']

    polls.each do |poll|
      next unless ['AP Top 25', 'Coaches Poll', 'Playoff Committee Rankings'].include?(poll['poll'])

      poll['ranks'].each do |rank|
        team = Team.find_by(name_short: rank['school'])

        if team.nil?
          puts '++++RANKING-TEAM++++'
          puts rank
          puts '++++++++++++++++++++'
        end

        Ranking.create!(week: @week, team:, poll: poll['poll'], rank: rank['rank'])
      end
    end

    true
  end
end

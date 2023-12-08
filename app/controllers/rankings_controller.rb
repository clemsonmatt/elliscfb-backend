class RankingsController < ApplicationController
  before_action :is_admin, only: [:import]

  def show
    season = Season.where(active: true).first
    week = Week.find_by(season: season, number: params[:id])

    polls = all_polls(week:)

    render json: polls, status: :ok
  end

  def import
    season = Season.where(active: true).first
    week = Week.find_by(season:, number: params[:id])

    status = ImportRankings.call(week)

    return render json: { error: 'Poll not available for week' }, status: :unprocessable_entity if status == false

    polls = all_polls(week:)

    render json: polls, status: :ok
  end

  private

  def all_polls(week:)
    return {
      ap_poll: poll_data(week:, poll: 'AP Top 25'),
      coaches_poll: poll_data(week:, poll: 'Coaches Poll'),
      playoff_poll: poll_data(week:, poll: 'Playoff Committee Rankings')
    }
  end

  def poll_data(week:, poll:)
    poll_rankings = []
    rankings = Ranking.where(week:, poll:).order(rank: :asc)

    rankings.each do |ranking|
      poll_rankings.push({
        team: ranking.team,
        rank: ranking.rank
      })
    end

    poll_rankings
  end
end

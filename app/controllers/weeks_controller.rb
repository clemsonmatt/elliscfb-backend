class WeeksController < ApplicationController
  def full_season
    season = Season.where(active: true).first
    weeks = Week.where(season: season)

    current_week = Week.current_week.first
    current_week = weeks.first if current_week.nil?

    render json: { weeks: weeks, current_week: current_week }
  end
end

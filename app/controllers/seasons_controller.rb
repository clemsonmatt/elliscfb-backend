class SeasonsController < ApplicationController
  def active_weeks
    season = Season.where(active: true).first

    render json: season.weeks
  end
end

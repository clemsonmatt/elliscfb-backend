class WeeksController < ApplicationController
  def games
    week = Week.find(params[:id])

    render json: week.games
  end
end

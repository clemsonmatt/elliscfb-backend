class ConferencesController < ApplicationController
  def index
    conferences = Conference.all.order(name: :asc)

    render json: conferences.to_json(include: :teams)
  end
end

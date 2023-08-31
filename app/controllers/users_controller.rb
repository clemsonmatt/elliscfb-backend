class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    @user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def details
    if @current_user.nil?
      return render json: {
        user: nil,
        roles: nil
      }
    end

    render json: {
      user: @current_user.api_details,
      roles: @current_user.permissions
    }
  end
end

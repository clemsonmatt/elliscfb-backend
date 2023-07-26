class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def details
    render json: {
      user: @current_user.api_details,
      roles: @current_user.permissions
    }
  end

  private

  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name)
  end
end

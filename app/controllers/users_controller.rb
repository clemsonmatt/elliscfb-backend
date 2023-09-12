class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    @user = User.new(user_create_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update(user_update_params)
      render json: @current_user.api_details
    else
      render json: { error: @current_user.errors.full_messages }, status: :unprocessable_entity
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

  def reset_password
    user = User.find_by(reset_token: params[:reset_token])

    # make sure we have a user
    return render json: { error: 'No account found' }, status: :unprocessable_entity if user.nil?

    # update password and clear reset_token
    if user.update(password: params[:password], reset_token: nil)
      render json: { success: true }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_create_params
    params.permit(:username, :first_name, :last_name, :email, :password)
  end

  def user_update_params
    params.permit(:username, :first_name, :last_name)
  end
end

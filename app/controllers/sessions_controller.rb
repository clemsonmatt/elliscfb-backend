class SessionsController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      roles = @user.permissions

      render json: {
        token: token,
        roles: roles,
        user: @user.api_details
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end
end

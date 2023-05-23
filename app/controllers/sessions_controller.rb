class SessionsController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = jwt_encode(user_id: @user.id)
      render json: {
        token: token,
        user: {
          id: @user.id,
          username: @user.username,
          name: @user.to_s,
          initials: @user.initials
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end
end

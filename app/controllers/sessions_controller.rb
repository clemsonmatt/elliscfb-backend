class SessionsController < ApplicationController
  skip_before_action :authenticate_request

  def login
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      # generate a new token for user
      token = SecureRandom.uuid
      expires_at = DateTime.now + 1.month
      UserSession.create(user: @user, token:, expires_at:)

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

  def forgot_password
    user = User.find_by(email: params[:email])

    # if we don't have a user, send success message so that we
    # don't let anyone know we didn't find an account with that email
    return render json: { success: true }, status: :ok if user.nil?

    begin
      # update the reset_token and send email
      ResetPasswordEmail.call(user)

      render json: { success: true }, status: :ok
    rescue => exception
      render json: { error: exception }, status: :unprocessable_entity
    end
  end
end

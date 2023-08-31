class ApplicationController < ActionController::API
  before_action :authenticate_request

  def is_admin
    return render json: { error: 'Unauthorized' }, status: 404 unless @current_user&.permissions == 'manage'
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    return false if token.nil?

    # find an active session
    session = UserSession.where(token:).where("expires_at > ?", DateTime.now).first

    # set current user
    @current_user = session.user unless session.nil?
  end
end

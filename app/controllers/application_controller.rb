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

    @current_user = User.find_by(token:)
  end
end

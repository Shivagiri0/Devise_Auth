class ApplicationController < ActionController::Base
  include PasswordHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def authenticate
    _current_user, _decoded_token = Jwt::Authenticator.call(
      headers: request.headers,
      access_token: params[:access_token]
    )
    @current_user = current_user
    @decoded_token = decoded_token
  end
end

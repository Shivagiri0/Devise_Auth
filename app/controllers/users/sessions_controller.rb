# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :check_failed_attempts, only: :create

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    auth = request.env['omniauth.auth']
    @user = User.find_by(email: auth.info.email) || User.create(email: auth.info.email)
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  def after_sign_up_path_for(resource)
    edit_user_registration_url(resource)
  end

  protected

  def failed_login(user)
    if user.failed_attempts >= 3
      user.lock_access!
      flash.now[:alert] = 'Your account has been locked due to multiple login attempts. Please contact support.'
    else
      flash.now[:alert] = 'Invalid email or password. Please try again.'
    end
  end

  def check_failed_attempts
    user = User.find_by(email: params[:user][:email])
    self.resource = user
    render :new
  end

  def clear_failed_attempts
    resource.update(failed_attempts: 3)
  end

  def check_user_confirmation
    user = User.find_by_email(params[:email])
    redirect_to new_confirmation_path(:user) unless user&.confirmed?
  end

  # If you have extra params to permit, append them to the sanitizer.

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in)
  end
end

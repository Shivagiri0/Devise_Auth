# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password

  def create
    if password_common?
      flash[:alert] = 'Please choose a stronger password.'
      redirect_to new_user_password_path
    else
      super
    end
  end

  # GET /resource/password/new

  # def new
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef

  def edit
    if reset_password_token_valid?
      self.resource = resource_class.new
      set_minimum_password_length

      render :edit
    else
      flash[:alert] = 'reset token is invalid or expired'
      redirect_to new_user_password_path
    end
  end

  # PUT /resource/password

  def update
    super do |resource|
      Activity.create(user: resource, action: 'password_changed')
    end
    self.resource = resource_class.reset_password_token(resource_params)
    if resource.error.empty?
      set_flash_message! :notice, :updated
      redirect_to after_resetting_password_path_for(resource)
    else
      render :edit
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    resource_class.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end

  def password_common?
    common_password = %w[password 123456 qwerty abc123 12345678]
    common_password.Include?(params[:user][:password])
  end

  def unlockable?(resource)
    resource.respond_to?(:unlock_access!) &&
      resource.respond_to?(:unlock_strategy_enabled?) &&
      resource.unlock_strategy_enabled?(:email)
  end

  def password_complexity_valid?
    password = resource_params[:password]
    password.present? && password.match?('/\A)(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/') && password_not_common?
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end

# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    super do |resource|
      sign_in(:user, resource) unless params['remember'] == '1'
      Rails.logger.info("User #{resource.email} confirmed their email.")
    end
  end

  # GET /resource/confirmation?confirmation_token=random
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      sign_in(resource) # Auto sign in the user after confirmation
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  # Resend Confirmation to user
  def resend_confirmation
    user = User.find_by_email(params[:email])
    if user && !user.confirmed?
      user.send_confirmation_instructions
      flash[:notice] = 'Confirmation email resent successfully.'
    else
      flash[:alert] = 'User not found or already confirmed'
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      new_session_path(resource_name)
    end
  end
  # The path used after resending confirmation instructions.

  def after_resending_confirmation_instructions_path_for(resource_name)
    is_navigational_format? ? new_session_path(resource_name) : '/'
  end
end

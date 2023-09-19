class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def ban
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end
    redirect_to users_path, notice: "User Access Locked: #{@user.access_locked?}"
  end

  def update
    if @user.update(user_params)
      sign_out_user
      redirect_to root_path, notice: 'Profile updated. Please sign in again.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def generate_password
    @random_password = generate_random_password
    respond_to do |format|
      format.js
    end
  end

  private

  def sign_out_user
    session.delete(:user_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :other_attributes)
  end
end

class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  def new; end

  def edit; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_sent"
      redirect_to static_pages_home_path
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def update
    if password_empty?
      @user.errors.add :password, t("cant_be_empty")
      render :edit
    elsif update_success?
      handle_update_success
    else
      handle_update_fail
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset_expired"
    redirect_to new_password_reset_url
  end

  def password_empty?
    user_params[:password].empty?
  end

  def update_success?
    @user.update user_params
  end

  def handle_update_fail
    flash.now[:danger] = t "password_reset_fail"
    render :edit
  end

  def handle_update_success
    log_in @user
    @user.update_column :reset_digest, nil
    flash[:success] = t "password_reset_success"
    redirect_to @user
  end
end

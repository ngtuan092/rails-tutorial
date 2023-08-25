class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      handle_authenticated user
    else
      handle_unauthenticated
    end
  end

  def destroy
    log_out
    redirect_to static_pages_home_path
  end

  private

  def handle_authenticated user
    if user.activated?
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "account_not_activated"
      redirect_to static_pages_home_path
    end
  end

  def handle_unauthenticated
    flash.now[:danger] = t "invalid_email_password_combination"
    render :new
  end
end

class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy(User.all, items: Settings.pagy.user.items)
  end

  def show
    @pagy, @microposts = pagy @user.microposts.newest,
                              items: Settings.pagy.micropost.items
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t "check_your_email"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("profile_updated")
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("user_deleted")
    else
      flash[:danger] = t("user_not_deleted")
    end
    redirect_to users_path
  end

  def following
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.pagy.user.items
    render :show_follow
  end

  def followers
    @title = t "followers"
    @pagy, @users = pagy @user.followers, items: Settings.pagy.user.items
    render :show_follow
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("user_not_found")
    redirect_to static_pages_home_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t("not_authorized")
    redirect_to current_user
  end

  def admin_user
    redirect_to @user unless current_user.admin?
  end
end

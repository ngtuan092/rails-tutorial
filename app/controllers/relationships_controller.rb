class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.nil?
      handle_user_not_found
    else
      current_user.follow @user
      respond_to_follow
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id])&.followed
    if @user.nil?
      handle_user_not_found
    else
      current_user.unfollow @user
      respond_to_follow
    end
  end

  private
  def handle_user_not_found
    flash[:danger] = t "user_not_found"
    redirect_to static_pages_home_path
  end

  def respond_to_follow
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
  end
end

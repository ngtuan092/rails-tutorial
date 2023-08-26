class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.nil?
      flash[:danger] = t "user_not_found"
      redirect_to static_pages_home_path
    else
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.turbo_stream
      end
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id])&.followed
    if @user.nil?
      flash[:danger] = t "user_not_found"
      redirect_to static_pages_home_path
    else
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.turbo_stream
      end
    end
  end
end

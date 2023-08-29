class MicropostsController < ApplicationController
  before_action :correct_user, only: %i(destroy)
  before_action :logged_in_user
  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      save_success
    else
      save_fail
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_deleted"
    else
      flash[:danger] = t "micropost_not_deleted"
    end
    redirect_to request.referer || static_pages_home_path
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "micropost_invalid"
    redirect_to static_pages_home_path
  end

  def save_success
    flash[:success] = t "micropost_created"
    redirect_to static_pages_home_path
  end

  def save_fail
    @pagy, @feed_items = pagy current_user.feed.newest,
                              items: Settings.pagy.micropost.items
    render "static_pages/home"
  end
end

class Users::PostsController < Users::ApplicationController
  def index
    @posts = @user.posts.includes(:category).order(id: :desc).page(params[:page])
  end

  def likes
    @posts = @user.like_topics.includes(:category, :user).order(id: :desc).page(params[:page])
    render :index
  end
end

class Admin::PostsController < Admin::ApplicationController
  before_action :find_post, only: [:show, :update, :trash, :restore]

  def index
    @posts = Post.includes(:user).order(id: :desc).page(params[:page])
  end

  def trashed
    @posts = Post.trashed.includes(:user).order(id: :desc).page(params[:page])
    render :index
  end

  def show
  end

  def update
    if @post.update_attributes params.require(:post).permit(:title, :category_id, :body)
      flash[:success] = I18n.t('admin.posts.flashes.successfully_updated')
      redirect_to admin_post_url(@post)
    else
      render :show
    end
  end

  def trash
    @post.trash
    flash[:success] = I18n.t('admin.posts.flashes.successfully_trashed')
    redirect_to admin_post_path(@post)
  end

  def restore
    @post.restore
    flash[:success] = I18n.t('admin.posts.flashes.successfully_restored')
    redirect_to admin_post_path(@post)
  end

  private

  def find_post
    @post = Post.with_trashed.find params[:id]
  end
end

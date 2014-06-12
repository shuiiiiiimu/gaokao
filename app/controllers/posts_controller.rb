class PostsController < ApplicationController
  before_action :login_required, :no_locked_required, except: [:index, :show, :search]
  before_action :find_post, only: [:edit, :update, :trash]

  def index
    @posts = Post.includes(:user, :category).page(params[:page])

    if params[:category_id]
      @category = Category.where(:id => params[:category_id]).first!
      @posts = @posts.where(category: @category)
    end

    # Set default tab
    unless %w(hot newest).include? params[:tab]
      params[:tab] = 'hot'
    end

    case params[:tab]
    when 'hot'
      @posts = @posts.order(hot: :desc)
    when 'newest'
      @posts = @posts.order(id: :desc)
    end
  end

  def search
    @posts = Post.search(
      query: {
        multi_match: {
          query: params[:q].to_s,
          fields: ['title', 'body']
        }
      },
      filter: {
        term: {
          trashed: false
        }
      }
    ).page(params[:page]).records
  end

  def show
    @post = Post.find params[:id]

    if params[:comment_id] and comment = @post.comments.find_by(id: params.delete(:comment_id))
      params[:page] = comment.page
    end

    @comments = @post.comments.includes(:user).order(id: :asc).page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def new
    @category = Category.where('lower(slug) = ?', params[:category_id].downcase).first if params[:category_id].present?
    @post = Post.new category: @category
  end

  def create
    @post = current_user.posts.create post_params
  end

  def edit
  end

  def update
    @post.update_attributes post_params
  end

  def trash
    @post.trash
    redirect_via_turbolinks_to posts_path
  end

  private

    def post_params
      params.require(:post).permit(:title, :category_id, :body)
    end

    def find_post
      @post = current_user.posts.find params[:id]
    end
end

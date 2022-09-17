class PostsController < ApplicationController
  before_action :require_login, only: %i[new create destroy]
  
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
    @comment = Comment.new
    @comments = Comment.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save!
    redirect_to posts_path, success: '投稿しました！'
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました！'
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end

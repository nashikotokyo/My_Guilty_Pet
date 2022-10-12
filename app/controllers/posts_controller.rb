class PostsController < ApplicationController
  before_action :require_login, only: %i[new create destroy tweet]

  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save!
    redirect_to tweet_post_path(@post), success: '投稿しました！'
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました！'
  end

  def ranking
    @top10_posts = Post.includes(:user).find(Like.group(:post_id).order('count(post_id) desc').limit(10).pluck(:post_id))
    @comment = Comment.new
  end

  def tweet
    @post = Post.find(params[:id])
    return if current_user.own?(@post)

    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end

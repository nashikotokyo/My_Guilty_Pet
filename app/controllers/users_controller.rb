class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.includes(:user).order(created_at: :desc)
    @user_like_posts = @user.like_posts.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end
end

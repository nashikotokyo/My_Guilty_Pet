class BookmarksController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @post = Post.find(params[:post_id])
    current_user.bookmark(@post)
  end

  def destroy
    @post = current_user.bookmarks.find(params[:id]).post
    current_user.unbookmark(@post)
  end
end

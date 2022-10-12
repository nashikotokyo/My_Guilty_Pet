class Development::SessionsController < ApplicationController
  def login_as
    user = User.find(params[:user_id])
    auto_login(user)
    redirect_to posts_path, success: 'ログインしました'
  end
end

class UserSessionsController < ApplicationController
  def new; end

  def destroy
    logout
    redirect_to login_path, success: 'ログアウトしました'
  end
end

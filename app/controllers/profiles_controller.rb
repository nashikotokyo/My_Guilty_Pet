class ProfilesController < ApplicationController
  before_action :require_login, only: %i[edit update]

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(profile_params)
      redirect_to user_path(@user), success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username)
  end
end

class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    return redirect_to root_path, warning: 'ログインをキャンセルしました' if params[:error] || params[:denied]

    provider = params[:provider]
    if (@user = login_from(provider))
      redirect_to root_path, success: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path, success: "#{provider.titleize}でログインしました"
      rescue StandardError
        redirect_to root_path, danger: "#{provider.titleize}ログインに失敗しました"
      end
    end
  end
end

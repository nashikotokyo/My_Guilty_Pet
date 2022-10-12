module SystemHelper
  # ログインの処理
  def login
    user = create(:user)
    visit "/login_as/#{user.id}"
  end
  
  # userを引数に渡すバージョン
  def login_as(user)
    visit "/login_as/#{user.id}"
  end
end
require 'rails_helper'

RSpec.describe 'いいね', type: :system do
  let!(:user) { create(:user) }
  let!(:post_by_others) { create(:post) }
  let!(:post_by_user) { create(:post, user: user) }
  before do
    login_as(user)
  end

  it '自分の投稿にいいねボタンが表示されないこと' do
    visit posts_path
    within "#post-#{post_by_user.id}" do
      expect(page).not_to have_css '.before-like-button'
    end
  end

  it '他人の投稿にいいねボタンが表示されること' do
    visit posts_path
    within "#post-#{post_by_others.id}" do
      expect(page).to have_css '.before-like-button'
    end
  end

  it 'いいねができること' do
    visit posts_path
    expect {
      within "#post-#{post_by_others.id}" do
        find('.before-like-button').click
        expect(page).to have_css '.after-like-button'
      end
    }.to change{user.like_posts.count}.by(1)
  end

  it 'いいねを取り消せること' do
    user.like(post_by_others)
    visit posts_path
    expect {
      within "#post-#{post_by_others.id}" do
        find('.after-like-button').click
        expect(page).to have_css '.before-like-button'
      end
    }.to change {user.like_posts.count}.by(-1)
  end
end



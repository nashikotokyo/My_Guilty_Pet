require 'rails_helper'

RSpec.describe 'ブックマーク', type: :system do
  let!(:user) { create(:user) }
  let!(:post_by_others) { create(:post) }
  let!(:post_by_user) { create(:post, user: user) }
  before do
    login_as(user)
  end

  it '自分の投稿にブックマークボタンが表示されないこと' do
    visit posts_path
    within "#post-#{post_by_user.id}" do
      expect(page).not_to have_css '.before-bookmark-button'
    end
  end

  it '他人の投稿にブックマークボタンが表示されること' do
    visit posts_path
    within "#post-#{post_by_others.id}" do
      expect(page).to have_css '.before-bookmark-button'
    end
  end

  it 'ブックマークができること' do
    visit posts_path
    expect {
      within "#post-#{post_by_others.id}" do
        find('.before-bookmark-button').click
        sleep 0.5
        expect(page).to have_css '.after-bookmark-button'
      end
    }.to change{user.bookmark_posts.count}.by(1)
  end

  it ' ブックマークを取り消せること' do
    user.bookmark(post_by_others)
    visit posts_path
    expect {
      within "#post-#{post_by_others.id}" do
        find('.after-bookmark-button').click
        sleep 0.5
        expect(page).to have_css '.before-bookmark-button'
      end
    }.to change {user.bookmark_posts.count}.by(-1)
  end
end

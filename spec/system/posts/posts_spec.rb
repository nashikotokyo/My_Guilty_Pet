require 'rails_helper'

RSpec.describe '投稿', type: :system do

  describe '投稿一覧' do
    let!(:user) { create(:user) }
    let!(:post_1_by_others) { create(:post) }
    let!(:post_2_by_others) { create(:post) }
    let!(:post_by_user) { create(:post, user: user) }

    it '全てのポストが表示されていること' do
      login_as(user)
      visit posts_path
      expect(page).to have_content post_1_by_others.body
      expect(page).to have_content post_2_by_others.body
      expect(page).to have_content post_by_user.body
    end

    context 'ログインしている場合' do
      before do
        login_as(user)
      end

      it 'いいねボタンとコメント入力欄が表示されていること' do
        visit posts_path
        expect(page).to have_css '.before-like-button'
        expect(page).to have_css '.comment-input-form'
      end

      it '自分の投稿にTwitterシェアボタンが表示されていること' do
        visit posts_path
        within "#post-#{post_by_user.id}" do
          expect(page).to have_css '.btn-twitter'
        end
      end
    end

    context 'ログインしていない場合' do
      it 'いいねボタン、コメント入力欄、Twitterシェアボタンが表示されていないこと' do
        visit posts_path
        expect(page).not_to have_css '.like-button'
        expect(page).not_to have_css '.comment-input-form'
        expect(page).not_to have_css '.btn-twitter'
      end
    end
  end

  describe '新規投稿' do
    let!(:user) { create(:user) }
    before do
      login_as(user)
    end

    it '画像を投稿できること' do
      visit new_post_path
      click_button '選択'
      attach_file '・ペットの画像を選択', Rails.root.join('spec', 'fixtures', 'fixture.png')
      click_button 'トリミング'
      fill_in '・ペットの名前を入力', with: 'ペットの名前を入力'
      find('#combine-btn-1').click
      fill_in '・犯行内容・罪名を入力', with: '犯行内容を入力'
      find('#combine-btn-2').click
      fill_in '・懸賞金額を入力', with: '懸賞金額を入力'
      find('#combine-btn-3').click
      click_button '次へ'
      fill_in 'キャプション(任意)', with: 'キャプションを入力'
      click_button '投稿'

      expect(page).to have_content '投稿しました！'
      expect(current_path).to eq tweet_post_path(user.posts.first)
    end
  end

  describe '投稿削除' do
    let!(:user) { create(:user) }
    let!(:post_1_by_others) { create(:post) }
    let!(:post_by_user) { create(:post, user: user) }
    before do
      login_as(user)
    end
    
    it '自分の投稿に削除ボタンが表示されること' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        expect(page).to have_css '.delete-button'
      end
    end

    it '他人の投稿には削除ボタンが表示されないこと' do
      visit posts_path
      within "#post-#{post_1_by_others.id}" do
        expect(page).not_to have_css '.delete-button'
      end
    end

    it '投稿が削除できること' do
      visit posts_path
      within "#post-#{post_by_user.id}" do
        page.accept_confirm { find('.delete-button').click }
      end
      expect(page).to have_content '投稿を削除しました'
      expect(page).not_to have_content post_by_user.body
    end
  end
end
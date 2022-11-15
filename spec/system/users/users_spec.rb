require 'rails_helper'

RSpec.describe 'ユーザー情報', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post_by_user) { create(:post, user: user) }
  let!(:post_by_other_user) { create(:post, user: other_user) }
  before do
    login_as(user)
  end

  describe 'プロフィール' do
    context '自分のプロフィールの場合' do

      it 'プロフィールを編集ボタンが表示されること' do
        visit user_path(user)
        expect(page).to have_content 'プロフィールを編集'
      end

      it 'ユーザー名を編集できること' do
        visit user_path(user)
        click_on('プロフィールを編集')
        fill_in 'ユーザー名', with: '編集されたユーザー名'
        click_button '更新'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content '編集されたユーザー名'
      end

      it '自分の投稿が表示されること' do
        visit user_path(user)
        expect(page).to have_content post_by_user.body
        expect(page).not_to have_content post_by_other_user.body
      end

      it '自分のブックマークした投稿が表示されること' do
        user.bookmark(post_by_other_user)
        visit user_path(user)
        click_on('保存済み')
        expect(page).to have_content post_by_other_user.body
      end
    end

    context '他人のプロフィールの場合' do
      it 'プロフィールを編集ボタンが表示されないこと' do
        visit user_path(other_user)
        expect(page).not_to have_content 'プロフィールを編集'
      end

      it 'お気に入りページが表示されないこと' do
        visit user_path(other_user)
        expect(page).not_to have_content 'お気に入り'
      end

      it 'そのユーザーの投稿が表示される' do
        visit user_path(other_user)
        expect(page).to have_content post_by_other_user.body
      end
    end
  end
end
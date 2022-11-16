require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  
  describe 'コメント投稿' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    before do
      login_as(user)
    end

    it 'コメントができること' do
      fill_in "input-comment-box-#{post.id}", with: 'コメントを入力'
      find('.comment-btn').click
      find("#summary-#{post.id}").click

      expect(page).to have_content 'コメントを入力'
    end
  end

  describe 'コメント削除' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:comment_by_user) { create(:comment, user: user, post: post) }
    let!(:comment_by_other_user) { create(:comment, user: other_user, post: post) }
    before do
      login_as(user)
    end
    
    it '自分のコメントに削除ボタンが表示されること' do
      find("#summary-#{post.id}").click
      within "#comment-#{comment_by_user.id}" do
        expect(page).to have_css '.delete-button'
      end
    end

    it '他人のコメントには削除ボタンが表示されないこと' do
      find("#summary-#{post.id}").click
      within "#comment-#{comment_by_other_user.id}" do
        expect(page).not_to have_css '.delete-button'
      end
    end

    it 'コメントが削除できること' do
      find("#summary-#{post.id}").click
      within "#comment-#{comment_by_user.id}" do
        page.accept_confirm { find('.delete-button').click }
      end
      expect(page).not_to have_content comment_by_user.body
    end
  end
end
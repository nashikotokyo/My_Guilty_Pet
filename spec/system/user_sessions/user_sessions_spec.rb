require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do

  describe 'ログイン' do
    it 'ログインできること' do
      login      
      expect(current_path).to eq posts_path
      expect(page).to have_content 'ログインしました'
    end
  end

  describe 'ログアウト' do
    before do
      login
    end
    it 'ログアウトできること' do
      click_on('ログアウト')
      expect(current_path).to eq login_path
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
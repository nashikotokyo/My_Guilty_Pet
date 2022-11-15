require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'バリデーション' do
    it 'user_idとpost_idの組み合わせが一意であること' do
      bookmark = create(:bookmark)
      same_bookmark = build(:bookmark, user_id: bookmark.user_id, post_id: bookmark.post_id)
      same_bookmark.valid?
      expect(same_bookmark.errors[:user_id]).to include('はすでに存在します')
    end
  end
end
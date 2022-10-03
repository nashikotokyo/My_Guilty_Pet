require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション' do
    it 'user_idとpost_idの組み合わせが一意であること' do
      like = create(:like)
      same_like = build(:like, user_id: like.user_id, post_id: like.post_id)
      same_like.valid?
      expect(same_like.errors[:user_id]).to include('はすでに存在します')
    end
  end
end
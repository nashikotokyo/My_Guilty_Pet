# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
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

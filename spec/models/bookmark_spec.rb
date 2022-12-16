# == Schema Information
#
# Table name: bookmarks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_bookmarks_on_post_id              (post_id)
#  index_bookmarks_on_user_id              (user_id)
#  index_bookmarks_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
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

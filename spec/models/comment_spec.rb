require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it '本文は必須であること' do
      comment = build(:comment, body: nil)
      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end

    it '本文は最大1000文字であること' do
      comment = build(:comment, body: "a" * 1001)
      comment.valid?
      expect(comment.errors[:body]).to include('は1000文字以内で入力してください')
    end
  end
end
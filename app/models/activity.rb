# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default("unread"), not null
#  subject_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_activities_on_subject  (subject_type,subject_id)
#  index_activities_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :subject, polymorphic: true
  belongs_to :user

  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1 }
  enum read: { unread: false, read: true }

  def redirect_path
    case action_type.to_sym
    when :commented_to_own_post
      posts_path(anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      posts_path(anchor: "post-#{subject.post.id}")
    end
  end
end

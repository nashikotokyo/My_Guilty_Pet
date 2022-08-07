# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :username, uniqueness: true, presence: true

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
end

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: {message: '不能为空'}
  validates :followed_id, presence: {message: '不能为空'}
end

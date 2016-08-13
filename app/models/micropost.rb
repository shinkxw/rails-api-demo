class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: {message: '不能为空'}
  validates :content, presence: {message: '不能为空'}, length: { maximum: 140, message: '太长了(最多140个字符)' }
end

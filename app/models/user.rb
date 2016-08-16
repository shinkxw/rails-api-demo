class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }
  validates :name, presence: {message: '不能为空'},
                   length: { maximum: 50, message: '太长了(最多50个字符)' }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: {message: '不能为空'},
                    length: { maximum: 255, message: '太长了(最多255个字符)' },
                    format: { with: VALID_EMAIL_REGEX, message: '格式有误' },
                    uniqueness: { case_sensitive: false, message: '该邮件已注册' }

  include InstanceMethodsOnActivation

  if {}.fetch(:validations, true)
    include ActiveModel::Validations

    validate do |record|
      record.errors.add(:password, :blank, message: "不能为空") unless record.password_digest.present?
    end

    validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED, message: "太长了(最多72个字符)"
    validates_confirmation_of :password, allow_blank: true, message: "与密码不相同"
  end

  validates :password, presence: {message: '不能为空'},
                       length: { minimum: 6, message: '太短了(最低6个字符)' },
                       allow_nil: true

  #  返回用户的动态流
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
  #  关注另一个用户
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  #  取消关注另一个用户
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  #  如果当前用户关注了指定的用户，返回 true
  def following?(other_user)
    following.include?(other_user)
  end
end

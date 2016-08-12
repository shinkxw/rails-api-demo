class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
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
end

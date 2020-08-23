class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze
  has_many :images, as: :imageable, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_many :rates, dependent: :destroy
  has_many :product_rates, through: :rates, source: :product

  has_many :suggests, dependent: :destroy
  has_many :product_suggests, through: :suggests, source: :product

  enum role: {member: 0, admin: 1}

  validates :name, presence: true,
            length: {maximum: Settings.validation.user.name_max}

  validates :email, presence: true,
            length: {maximum: Settings.validation.user.email_max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: true}

  validates :address, presence: true

  validates :phone, presence: true,
            format: {with: VALID_PHONE_REGEX}

  validates :password, presence: true,
            length: {minimum: Settings.validation.user.pass_min},
            allow_nil: true
  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end

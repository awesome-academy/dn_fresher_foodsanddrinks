class User < ApplicationRecord
  has_many :images, as: :imageable, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_many :rates, dependent: :destroy
  has_many :product_rates, through: :rates, source: :product

  has_many :suggests, dependent: :destroy
  has_many :product_suggests, through: :suggests, source: :product

  enum role: {member: 0, admin: 1}
end

class Product < ApplicationRecord
  belongs_to :category

  has_many :images, as: :imageable, dependent: :destroy

  has_many :suggests, dependent: :destroy
  has_many :user_suggests, through: :suggests, source: :user

  has_many :rates, dependent: :destroy
  has_many :user_rates, through: :rates, source: :user

  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details, source: :order
end

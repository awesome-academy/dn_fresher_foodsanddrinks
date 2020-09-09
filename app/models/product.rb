class Product < ApplicationRecord
  belongs_to :category

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true,
    reject_if: proc{|attributes| attributes["image_url"].blank?}

  has_many :rates, dependent: :destroy
  has_many :user_rates, through: :rates, source: :user

  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details, source: :order

  validates :name, presence: true
  validates :information, presence: true
  validates :price, presence: true,
            numericality: {greater_than: Settings.validation.number.greater}
  validates :quantity, presence: true,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.validation.number.greater}

  delegate :name, to: :category, prefix: true

  scope :alphabet_name, ->{order name: :asc}
  scope :search_by_name, ->(name){where("name LIKE ?", "%#{name}%")}
end

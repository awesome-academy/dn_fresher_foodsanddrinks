class Order < ApplicationRecord
  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, ordered: 1, confirmed: 2, refuse: 3}
end

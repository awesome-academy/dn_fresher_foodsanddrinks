class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
            numericality: {only_integer: true,
                           greater_than: Settings.validation.number.greater}
  validates :current_price, presence: true,
            numericality: {greater_than: Settings.validation.number.greater}
end

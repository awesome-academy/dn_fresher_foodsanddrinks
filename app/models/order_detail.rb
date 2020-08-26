class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
            numericality: {only_integer: true,
                           greater_than: Settings.validation.number.greater}
  validates :current_price, presence: true,
            numericality: {greater_than: Settings.validation.number.greater}

  validate :product_present
  validate :order_present

  before_save :finalize

  private

  def product_present
    return if product

    errors.add(:product, :product_nil)
  end

  def order_present
    return order

    errors.add(:order, :order_nil)
  end
end

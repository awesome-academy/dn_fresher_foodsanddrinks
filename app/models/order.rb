class Order < ApplicationRecord
  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, confirmed: 1, refuse: 2}

  after_save :update_quantity_product, :save_order_details
  before_create :set_total

  def total_price
    order_details.reduce(0) do |sum, order_detail|
      if order_detail.valid?
        sum + (order_detail.quantity * order_detail.current_price)
      else
        0
      end
    end
  end

  private

  def update_quantity_product
    order_details.map do |od|
      @quantity = od.quantity
      @product = od.product
      @product.update(quantity: (@product.quantity - @quantity))
    end
  end

  def set_total
    self[:total] = total_price
  end

  def save_order_details
    order_details.each do |od|
      od.save!
    end
  end
end

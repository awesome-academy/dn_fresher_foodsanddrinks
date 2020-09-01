class Order < ApplicationRecord
  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: {waiting: 0, confirmed: 1, refuse: 2, cancel: 4}

  after_create :update_quantity_product, :save_order_details

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

  def confirm
    update_columns status: Order.statuses[:confirmed]
  end

  def link_confirm_expired?
    created_at < Settings.mail.expired.hours.ago
  end

  private

  def update_quantity_product
    order_details.map do |od|
      @product = od.product
      @product.update(quantity: (od.product_quantity - od.quantity))
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

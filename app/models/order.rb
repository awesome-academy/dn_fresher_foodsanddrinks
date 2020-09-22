class Order < ApplicationRecord
  belongs_to :user

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: {waiting: 0, ordered: 1, confirmed: 2, refused: 3, canceled: 4}

  delegate :name, to: :user, prefix: true

  scope :newest_time, ->{order created_at: :desc}

  after_create :update_quantity_product_minus, :save_order_details

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

  def verify_order
    ordered!
  end

  def update_status status
    if status == Order.statuses[:confirmed]
      update_quantity_product_minus if refused?
      confirmed!
    elsif status == Order.statuses[:refused]
      refused!
      update_quantity_product_plus
    end
  end

  def cancel
    canceled!
    update_quantity_product_plus
  end

  def link_confirm_expired?
    created_at < Settings.mail.expired.hours.ago
  end

  private

  def update_quantity_product_minus
    order_details.map do |od|
      @product = od.product
      @product.update!(quantity: (od.product_quantity - od.quantity))
    end
  end

  def update_quantity_product_plus
    order_details.map do |od|
      @product = od.product
      @product.update!(quantity: (od.product_quantity + od.quantity))
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

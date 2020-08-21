class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, numericality:
    {only_integer: true, greater_than: Settings.validation.number.greater,
     less_than: Settings.validation.number.less}
end

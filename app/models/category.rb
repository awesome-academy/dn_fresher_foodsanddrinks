class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true

  scope :alphabet_name, ->{order name: :asc}
end

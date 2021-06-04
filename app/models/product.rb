class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :price, numericality: {only_integer: true, greater_than: 0}
  validates :quantity, numericality: {only_integer: true, greater_than: 0}

  scope :min_price, ->{minimum :price}
  scope :max_price, ->{maximum :price}
end

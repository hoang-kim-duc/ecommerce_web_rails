class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy

  validates :name, presence: true
  validates :price, numericality: {only_integer: true, greater_than: 0}
  validates :quantity, numericality: {only_integer: true, greater_than: 0}

  scope :name_asc, ->{order :name}
  scope :newest, ->{order created_at: :desc}
  scope :price_asc, ->{order :price}
  scope :price_desc, ->{order price: :desc}
  scope :name_asc, ->{order :name}
  scope :name_asc, ->{order :name}
  scope :search, ->(pattern){where "name like ?", "%#{pattern}%"}
  scope :min_price, ->{minimum :price}
  scope :max_price, ->{maximum :price}
  scope :with_price, ->(min, max){where "price >= ? and price <= ?", min, max}
end

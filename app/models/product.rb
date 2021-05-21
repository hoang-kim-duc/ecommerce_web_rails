class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy

  scope :asc_by_name, ->{order :name}
  scope :search, ->(pattern){where "name like ?", "%#{pattern}%"}
  scope :min_price, ->{minimum :price}
  scope :max_price, ->{maximum :price}
  scope :with_price, ->(min, max){where "price >= ? and price <= ?", min, max}
end

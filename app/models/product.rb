class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy

  scope :asc_by_name, ->{order :name}
end

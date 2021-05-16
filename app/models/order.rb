class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :delivery_address

  enum status: {canceled: 0, pending: 1, approved: 2, shipping: 3, finish: 4}

  scope :newest_first, ->{order created_at: :desc}
end

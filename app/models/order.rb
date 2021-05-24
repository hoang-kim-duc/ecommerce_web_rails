class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :delivery_address
  belongs_to :user

  enum status: {pending: 0, approved: 1, shipping: 2, finish: 3,
                canceled: 4, rejected: 6}

  scope :newest_first, ->{order created_at: :desc}
  scope :status, ->(status){where status: status}

  delegate :name, :phone, :address, to: :delivery_address, prefix: true
  delegate :email, to: :user, prefix: true
end

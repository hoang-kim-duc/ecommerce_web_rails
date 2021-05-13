class Product < ApplicationRecord
  belongs_to :category

  scope :asc_by_name, ->{order :name}
end

class Category < ApplicationRecord
  belongs_to :father, class_name: Category.name, foreign_key: :father_id,
                      dependent: :destroy, optional: true
  has_many :children, class_name: Category.name, foreign_key: :father_id,
                                                 dependent: :destroy
  has_many :products, dependent: :destroy

  scope :have_father, ->(father_id){where father_id: father_id}
  scope :roots, ->{where father_id: nil}

  def ancestors
    ancestors = [self]
    current = self
    while current.father
      ancestors << current.father
      current = current.father
    end
    ancestors.reverse
  end

  def all_product_from_descendants
    result = products
    children.each do |category|
      result = result.or(category.all_product_from_descendants)
    end
    result
  end
end

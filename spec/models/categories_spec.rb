RSpec.describe Category, type: :model do
  describe "associations" do
    it {should belong_to(:father).class_name(Category.name).optional}
    it {should have_many(:children).class_name(Category.name)}
    it {should have_many :products}
  end
end

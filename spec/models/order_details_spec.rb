RSpec.describe OrderDetail, type: :model do
  describe "validations" do
    it {should validate_numericality_of(:quantity).only_integer
                                                  .is_greater_than(0)}
    it {should validate_numericality_of(:price).only_integer
                                               .is_greater_than(0)}
  end

  describe "associations" do
    it {should belong_to :order}
    it {should belong_to :product}
  end
end

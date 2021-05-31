RSpec.describe Order, type: :model do
  describe "validations" do
    it {should allow_value(nil).for(:total)}
    it {should validate_numericality_of(:total).only_integer
                                               .is_greater_than(0)}
  end

  describe "associations" do
    it {should belong_to :delivery_address}
    it {should belong_to :user}
  end
end

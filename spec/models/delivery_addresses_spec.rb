RSpec.describe DeliveryAddress, type: :model do
  let!(:invalid_phone){"0123 abc 456"}
  let!(:valid_phone){"0123 789 456"}

  describe "validations" do
    it {should validate_length_of(:name).is_at_most(Settings.user.name_max_len)}
    it {should validate_length_of(:phone).is_at_most(Settings.user.phone_max_len)}
    it {should_not allow_value(invalid_phone).for(:phone)}
    it {should allow_value(valid_phone).for(:phone)}
  end

  describe "associations" do
    it {should belong_to :user}
  end
end

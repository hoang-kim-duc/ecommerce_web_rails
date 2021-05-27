RSpec.describe User, type: :model do
  it "have email downcase before save" do
    user = create :customer
    expect(user.email).to eql user.email.downcase
  end

  describe "validations" do
    it {should have_secure_password}
    it {should validate_presence_of(:name)}
    it {should validate_length_of(:name).is_at_most(Settings.user
                                                            .name_max_len)}
    it {should validate_length_of(:password)
                  .is_at_least(Settings.user.pwd_min_len)}
    it {should validate_presence_of(:password)}
    it {should validate_presence_of(:email)}
    it {should validate_length_of(:email).is_at_most(Settings.user
                                                             .email_max_len)}
    context "valid unique email" do
      subject {build :customer}
      it {should validate_uniqueness_of(:email).case_insensitive}
    end
  end

  describe "associations" do
    it {is_expected.to have_many :delivery_addresses}
    it {is_expected.to have_many :orders}
  end
end

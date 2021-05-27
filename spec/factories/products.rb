FactoryBot.define do
  factory :product do
    name {"Sample Product"}
    manufacturer {Faker::Device.manufacturer}
    detail {"Detail holder"}
    quantity {Faker::Number.within(range: 5..20)}
    price {Faker::Number.within(range: 10..30) * 1000000}
    category
  end
end

User.create!(
  name: "Sample User",
  email: "test-user@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 1,
  activated: true,
  activated_at: Time.zone.now
)

30.times do |n|
  name = Faker::Name.name
  email = "user-email#{n + 1}@rails.com"
  password = "123456"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

Category.create!(
  title: "Demo",
  father_id: nil
)

30.times do |n|
  Product.create!(
    name: Faker::Device.unique.model_name,
    manufacturer: Faker::Device.manufacturer,
    detail: "Product #{n + 1} detail",
    quantity: Faker::Number.within(range: 5..20),
    price: Faker::Number.within(range: 10..30) * 1000000,
    category_id: 1
  )
end

5.times do |n|
  DeliveryAddress.create!(
    name: Faker::Name.unique.name,
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    user_id: User.all.ids.sample
  )
end

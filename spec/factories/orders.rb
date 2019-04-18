FactoryBot.define do
  factory :order do
    purchase_channel
    client
    delivery_address { Faker::Address.street_address }
    delivery_service { rand(1..3) }
    total_value { Faker::Number.decimal(2) }
    line_items { [Faker::Games::Pokemon.name, Faker::Games::Pokemon.name] }
  end
end

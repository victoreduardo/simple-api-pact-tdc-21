FactoryBot.define do
  factory :metric do
    name { Faker::Name.first_name }
    value { Faker::Number.decimal(l_digits: 2) }
    date { Faker::Time.between(from: DateTime.now - 3.days, to: DateTime.now + 3.days) }
  end
end

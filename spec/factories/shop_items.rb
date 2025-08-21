FactoryBot.define do
  factory :shop_item do
    trait :green_tea do
      code { 'GR1' }
      name { 'Green Tea' }
      price { 3.11 }
    end

    trait :strawberries do
      code { 'SR1' }
      name { 'Strawberries' }
      price { 5.00 }
    end

    trait :coffee do
      code { 'CF1' }
      name { 'Coffee' }
      price { 11.23 }
    end
  end
end

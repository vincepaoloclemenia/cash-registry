FactoryBot.define do
  factory :purchase_item do
    association :shop_item
    association :purchase

    quantity { 0 }
    discounted_price { nil }
    amount_without_discount { 0.0 }

    trait :green_tea do
      after(:build) do |item|
        item.shop_item = create(:shop_item, :green_tea)
      end
    end

    trait :coffee do
      after(:build) do |item|
        item.shop_item = create(:shop_item, :coffee)
      end
    end

    trait :strawberries do
      after(:build) do |item|
        item.shop_item = create(:shop_item, :strawberries)
      end
    end
  end
end

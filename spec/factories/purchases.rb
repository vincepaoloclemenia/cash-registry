FactoryBot.define do
  factory :purchase do
    purchased_at { nil }
    status { Purchase::CHECKED_OUT }
    total_amount_paid { 0.0 }
    discounted_price { 0.0 }
    amount_without_discount { 0.0 }
  end
end

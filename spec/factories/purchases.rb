FactoryBot.define do
  factory :purchase do
    purchased_at { "2025-08-21 19:41:19" }
    status { "MyString" }
    total_amount_paid { "9.99" }
    discounted_price { "9.99" }
    amount_without_discount { "9.99" }
  end
end

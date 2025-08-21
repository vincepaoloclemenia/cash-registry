FactoryBot.define do
  factory :purchase_item do
    quantity { 1 }
    discounted_price { "9.99" }
    amount_without_discount { "9.99" }
  end
end

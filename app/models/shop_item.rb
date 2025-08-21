class ShopItem < ApplicationRecord
  has_many :purchase_items
  has_many :purchases, through: :purchase_items
end

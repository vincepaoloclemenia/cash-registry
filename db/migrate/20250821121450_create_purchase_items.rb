class CreatePurchaseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_items do |t|
      t.integer :quantity, default: 1, null: false
      t.decimal :discounted_price, precision: 10, scale: 2
      t.decimal :amount_without_discount, precision: 10, scale: 2
      t.belongs_to :purchase, index: true
      t.belongs_to :shop_item, index: true

      t.timestamps
    end
  end
end

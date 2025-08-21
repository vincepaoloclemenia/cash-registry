class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.datetime :purchased_at, index: true
      t.string :status, default: 'checked_out', null: false, index: true
      t.decimal :total_amount_paid, scale: 2, precision: 10
      t.decimal :discounted_price, scale: 2, precision: 10
      t.decimal :amount_without_discount, scale: 2, precision: 10

      t.timestamps
    end
  end
end

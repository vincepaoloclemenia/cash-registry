class CreateShopItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shop_items do |t|
      t.string :name, null: false, index: true
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end

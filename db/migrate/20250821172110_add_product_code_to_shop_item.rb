class AddProductCodeToShopItem < ActiveRecord::Migration[7.1]
  def change
    add_column :shop_items, :code, :string, null: false

    add_index :shop_items, :code
  end
end

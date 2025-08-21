class AddActualQuantityTakenToPurchaseItems < ActiveRecord::Migration[7.1]
  def change
    add_column :purchase_items, :actual_quantity_taken, :integer, default: 0, null: false
  end
end

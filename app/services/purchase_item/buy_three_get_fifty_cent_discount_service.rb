class PurchaseItem
  class BuyThreeGetFiftyCentDiscountService < PromoService
    private

    def assign_modified_attributes
      purchase_item.discounted_price = calculated_discounted_amount
      purchase_item.amount_without_discount = quantity * price
    end

    def calculated_discounted_amount
      quantity * (price - 0.50)
    end
  end
end
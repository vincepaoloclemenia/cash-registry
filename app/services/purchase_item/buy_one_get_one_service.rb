class PurchaseItem
  class BuyOneGetOneService < PromoService

    private

    def raw_quantity
      @raw_quantity ||= quantity
    end

    def assign_modified_attributes
      purchase_item.actual_quantity_taken = calculated_quantity
      purchase_item.discounted_price = calculated_discounted_amount
      purchase_item.amount_without_discount = calculated_amount_without_discount
    end

    def calculated_discounted_amount
      raw_quantity * price
    end

    def calculated_quantity
      raw_quantity * 2
    end

    def calculated_amount_without_discount
      calculated_quantity * price
    end
  end
end
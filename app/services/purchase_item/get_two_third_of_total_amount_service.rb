class PurchaseItem
  class GetTwoThirdOfTotalAmountService < PromoService

    private

    def assign_modified_attributes
      purchase_item.discounted_price = calculated_discounted_amount
      purchase_item.amount_without_discount = full_price
    end

    def full_price
      @full_price ||= quantity * price
    end

    def two_third_discount
      @two_third_discount ||= (2.0/3.0).to_f
    end

    def calculated_discounted_amount
      full_price * two_third_discount
    end
  end
end
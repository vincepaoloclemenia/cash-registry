class Purchase
  class CheckoutService < ModelService

    attr_reader :purchase, :calculated_discounted_amount, :amount_without_discount

    def initialize(purchase)
      @purchase = purchase
      @calculated_discounted_amount = 0.0
      @amount_without_discount = 0.0
    end

    def result
      purchase.purchase_items.each do |purchase_item|
        dummy_item = PurchaseItem.new(**purchase_item.attributes.slice('quantity', 'shop_item_id'))

        dummy_item.send(:assign_attributes_by_promo)
        @calculated_discounted_amount += dummy_item.discounted_price.presence || dummy_item.amount_without_discount
        @amount_without_discount += dummy_item.amount_without_discount
      end

      purchase.amount_without_discount = amount_without_discount
      purchase.discounted_price = calculated_discounted_amount
    end
  end
end
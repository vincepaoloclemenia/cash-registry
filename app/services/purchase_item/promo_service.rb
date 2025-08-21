class PurchaseItem
  class PromoService < ModelService
    attr_reader :purchase_item

    delegate :price, :quantity, :amount_without_discount, to: :purchase_item

    def initialize(purchase_item)
      @purchase_item = purchase_item
    end

    def result
      assign_modified_attributes
      super
    end
  end
end
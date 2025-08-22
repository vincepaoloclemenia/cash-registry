class PurchaseItem < ApplicationRecord
  PROMOS = {
    gr1: BuyOneGetOneService,
    sr1: BuyThreeGetFiftyCentDiscountService,
    cf1: GetTwoThirdOfTotalAmountService
  }

  belongs_to :purchase
  belongs_to :shop_item

  delegate :price, :code, to: :shop_item

  before_validation :assign_attributes_by_promo

  after_update :touch_purchase, if: -> { discounted_price_previously_changed? && amount_without_discount_previously_changed? }

  accepts_nested_attributes_for :purchase_items,
                                allow_destroy: true,
                                reject_if: -> { new_record? && quantity <= 0 }
  private

  def assign_attributes_by_promo
    item_code = code.downcase.to_sym
    return PROMOS[item_code].run!(self) if item_code == :gr1 || (self.quantity >= 3 && %i[sr1 cf1].include?(item_code))

    self.discounted_price = self.quantity * price
    self.amount_without_discount = self.quantity * price
  end

  def touch_purchase
    return if (discounted_price_changes = previous_changes['discounted_price']).blank? || (amount_without_discount_changes = previous_changes['amount_without_discount']).blank?

    transaction do
      purchase.lock!
      pre_calculated_prices = purchase.attributes.slice('discounted_price', 'amount_without_discount').symbolize_keys

      purchase.update_columns(
        discounted_price: pre_calculated_prices[:discounted_price] - discounted_price_changes[0] + discounted_price_changes[1],
        amount_without_discount: pre_calculated_prices[:amount_without_discount] - amount_without_discount_changes[0] + amount_without_discount_changes[1],
        updated_at: Time.current
      )
    end
  end
end

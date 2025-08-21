class PurchaseItem < ApplicationRecord
  PROMOS = {
    gr1: BuyOneGetOneService,
    sr1: BuyThreeGetFiftyCentDiscountService,
    cf1: GetTwoThirdOfTotalAmountService
  }

  belongs_to :purchase
  belongs_to :shop_item

  delegate :price, :code, to: :shop_item

  before_validation :assign_attributes_by_promo, if: -> { PROMOS.keys.include? code.downcase.to_sym }

  private

  def assign_attributes_by_promo
    item_code = code.downcase.to_sym
    return PROMOS[item_code].run!(self) if item_code == :gr1 || (self.quantity >= 3 && %i[sr1 cf1].include?(item_code))

    self.amount_without_discount = self.quantity * price
  end
end

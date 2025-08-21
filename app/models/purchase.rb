class Purchase < ApplicationRecord
  STATUSES = [
    CHECKED_OUT = 'checked_out'.freeze,
    COMPLETED = 'completed'.freeze,
    CANCELLED = 'cancelled'.freeze
  ]

  has_many :purchase_items
  has_many :shop_items, through: :purchase_items

  validates :status, inclusion: { in: STATUSES }

  before_validation { CheckoutService.run!(self) }
end

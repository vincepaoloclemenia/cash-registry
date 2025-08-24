class Purchase < ApplicationRecord
  STATUSES = [
    CHECKED_OUT = 'checked_out'.freeze,
    COMPLETED = 'completed'.freeze,
    CANCELLED = 'cancelled'.freeze
  ]

  has_many :purchase_items, dependent: :destroy
  has_many :shop_items, through: :purchase_items

  validates :status, inclusion: { in: STATUSES }
  validate :must_have_purchase_items

  before_validation { CheckoutService.run!(self) }

  accepts_nested_attributes_for :purchase_items,
                                allow_destroy: true,
                                reject_if: -> (attribs) { attribs['id'].blank? && (attribs['quantity'].blank? || attribs['quantity'] <= 0) }
  STATUSES.each do |status|
    define_method("mark_as_#{status}!") do
      update!(status: status)
    end
  end

  private

  def must_have_purchase_items
    if purchase_items.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "You must add at least one item to your purchase")
    end
  end
end

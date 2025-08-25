class Purchase < ApplicationRecord
  include PurchasingConcerns

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
                                reject_if: -> (attribs) { attribs['id'].blank? && (attribs['quantity'].blank? || attribs['quantity'].to_i <= 0) }
  STATUSES.each do |status|
    define_method("mark_as_#{status}!") do
      attributes_to_update = { status: status }.tap do |hash|
        hash[:purchased_at] = Time.current if status == COMPLETED
      end

      update! **attributes_to_update
    end

    define_method("#{status}?") do
      self.status == status
    end
  end

  def name
    "#{slug_prefix}-#{slug_suffix}"
  end

  private

  def slug_prefix
    case status
    when CHECKED_OUT
      'CO'
    when COMPLETED
      'C'
    else
      'XC'
    end
  end

  def slug_suffix
    case status
    when CHECKED_OUT, CANCELLED
      created_at
    else
      purchased_at
    end.to_i
  end

  def must_have_purchase_items
    if purchase_items.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "You must add at least one item to your purchase")
    end
  end
end

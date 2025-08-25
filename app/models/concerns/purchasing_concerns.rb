module PurchasingConcerns
  def self.included(base)

    base.instance_eval { include InstanceMethods }
  end

  module InstanceMethods
    def discounted?
      discounted_price < amount_without_discount
    end
  end
end
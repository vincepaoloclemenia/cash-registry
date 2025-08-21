require 'rails_helper'

RSpec.describe PurchaseItem, type: :model do
  let(:green_tea) { create(:shop_item, :green_tea) }
  let(:strawberries) { create(:shop_item, :strawberries) }
  let(:coffee) { create(:shop_item, :coffee) }

  before { purchase_item.valid? } # trigger before_validation

  context 'when purchasing green tea with BOGO' do
    let(:purchase_item) { build(:purchase_item, quantity: 1, shop_item: green_tea) }

    it { expect(purchase_item.quantity).to eq(1) }
    it { expect(purchase_item.actual_quantity_taken).to eq(2) }
    it { expect(purchase_item.discounted_price).to eq(green_tea.price) }
    it { expect(purchase_item.amount_without_discount).to eq(green_tea.price * 2) }
  end

  context 'when purchasing 2 orders of strawberries' do
    let(:purchase_item) { build(:purchase_item, quantity: 2, shop_item: strawberries) }

    it { expect(purchase_item.quantity).to eq(2) }
    it { expect(purchase_item.discounted_price).to be_blank }
    it { expect(purchase_item.amount_without_discount).to eq(strawberries.price * 2) }
  end

  context 'when purchasing 3 or more orders of strawberries' do
    let(:purchase_item) { build(:purchase_item, quantity: 4, shop_item: strawberries) }

    it { expect(purchase_item.discounted_price.to_f).to eq(18.00) }
    it { expect(purchase_item.amount_without_discount).to eq(strawberries.price * 4) }
  end

  context 'when buying coffee' do
    let(:purchase_item) { build(:purchase_item, quantity: 1, shop_item: coffee) }

    it { expect(purchase_item.quantity).to eq(1) }
    it { expect(purchase_item.discounted_price).to be_blank }
    it { expect(purchase_item.amount_without_discount).to eq(coffee.price) }
  end

  context 'when buying 3 or more coffees' do
    let(:purchase_item) { build(:purchase_item, quantity: 5, shop_item: coffee) }

    it { expect(purchase_item.discounted_price.to_f).to eq(37.43) }
    it { expect(purchase_item.amount_without_discount).to eq(coffee.price * 5) }
  end
end

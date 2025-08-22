require 'rails_helper'

RSpec.describe PurchaseItem, type: :model do
  let(:green_tea) { create(:shop_item, :green_tea) }
  let(:strawberries) { create(:shop_item, :strawberries) }
  let(:coffee) { create(:shop_item, :coffee) }

  describe 'new record' do
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
      it { expect(purchase_item.discounted_price).to eq(strawberries.price * 2) }
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
      it { expect(purchase_item.discounted_price).to eq(coffee.price) }
      it { expect(purchase_item.amount_without_discount).to eq(coffee.price) }
    end

    context 'when buying 3 or more coffees' do
      let(:purchase_item) { build(:purchase_item, quantity: 5, shop_item: coffee) }

      it { expect(purchase_item.discounted_price.to_f).to eq(37.43) }
      it { expect(purchase_item.amount_without_discount).to eq(coffee.price * 5) }
    end
  end

  context 'when updating purchase item' do
    let(:green_tea) { create(:shop_item, :green_tea) }
    let(:purchase_item) { create(:purchase_item, shop_item: green_tea, quantity: 3) }
    let(:purchase) do
      build(
        :purchase,
        purchase_items: [purchase_item]
      )
    end

    before { purchase.save! }

    it do
      expect { purchase_item.update!(quantity: 1) }.to change(purchase_item, :actual_quantity_taken).from(6).to(2)
    end

    it do
      expect do
        purchase_item.update!(quantity: 1)
      end.to change(purchase_item, :discounted_price).from(9.33.to_d).to(3.11.to_d)
    end

    it do
      expect do
        purchase_item.update!(quantity: 1)
      end.to change(purchase.reload, :discounted_price).from(9.33.to_d).to(3.11.to_d)
    end

    context 'when purchased item is strawberries' do
      let(:strawberries) { create(:shop_item, :strawberries) }
      let(:purchase_item) { create(:purchase_item, shop_item: strawberries, quantity: 4) }

      it { expect(purchase.discounted_price).to eq(purchase_item.discounted_price) }
      
      context 'when quatity changes down to 2' do
        before { purchase_item.update!(quantity: 2) }

        it { expect(purchase_item.reload.quantity).to eq(2) }
        it { expect(purchase_item.reload.discounted_price.to_f).to eq(10.00) }
        it { expect(purchase_item.reload.amount_without_discount.to_f).to eq(10.00) }
      end
    end
  end
end

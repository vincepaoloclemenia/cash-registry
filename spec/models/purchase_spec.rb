require 'rails_helper'

RSpec.describe Purchase, type: :model do
  let(:purchase) { build(:purchase) }
  let(:green_tea) { build(:purchase_item, :green_tea, quantity: 3) }
  let(:strawberries) { build(:purchase_item, :strawberries, quantity: 5) }
  let(:coffees) { build(:purchase_item, :coffee, quantity: 4) }

  context 'when validation is ran without purchase items' do
    before { purchase.valid? }

    it { expect(purchase.discounted_price.to_f).to eq(0.0) }
    it { expect(purchase.amount_without_discount.to_f).to eq(0.0) }
    it { expect(purchase.total_amount_paid.to_f).to eq(0.0) }
  end

  context 'when purchasing green_tea' do
    let(:purchase) do
      build(
        :purchase,
        purchase_items: [green_tea]
      )
    end

    before { purchase.valid? }

    it { expect(purchase.discounted_price.to_f).to eq(9.33) }
    it { expect(purchase.amount_without_discount.to_f).to eq(18.66) }

    context 'when adding 5 purchase of strawberries' do
      let(:purchase) do
        build(
          :purchase,
          purchase_items: [green_tea, strawberries]
        )
      end

      it { expect(purchase.discounted_price.to_f).to eq(31.83) }
      it { expect(purchase.amount_without_discount.to_f).to eq(43.66) }

      context 'when adding 4 coffees' do
        let(:purchase) do
          build(
            :purchase,
            purchase_items: [green_tea, strawberries, coffees]
          )
        end

        it { expect(purchase.discounted_price.to_f).to eq(61.78) }
        it { expect(purchase.amount_without_discount.to_f).to eq(88.58) }
      end
    end
  end

  context 'when saved' do
    let(:purchase) do
      build(
        :purchase,
        purchase_items: [green_tea, strawberries, coffees]
      )
    end

    before { purchase.save! }

    it { expect(purchase.reload.discounted_price).to eq(purchase.purchase_items.pluck(:discounted_price).map(&:to_f).sum) }
    it { expect(purchase.reload.amount_without_discount).to eq(purchase.purchase_items.pluck(:amount_without_discount).map(&:to_f).sum) }
  end
end

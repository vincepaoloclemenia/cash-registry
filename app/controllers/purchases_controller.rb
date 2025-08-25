class PurchasesController < ApplicationController
  before_action on: %i[new edit] do
    @shop_items = ShopItem.all
  end

  before_action :find_purchase, only: %i[update edit show mark_as_cancelled mark_as_completed]

  def index
    @purchases = Purchase.all.order(:created_at, :purchased_at)
  end

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)

    if @purchase.save
      redirect_to purchase_path(@purchase), notice: 'Successfully checkedout'
    else
      redirect_to root_path, alert: @purchase.errors.full_messages.to_sentence
    end
  end

  def edit
    @purchase_items = @purchase.purchase_items.includes(:shop_item)
  end

  def show ; end

  def update
    if @purchase.update(purchase_params)
      redirect_to purchase_path(@purchase), notice: 'Successfully updated'
    else
      redirect_to edit_purchase_path(@purchase), alert: @purchase.errors.full_messages.to_sentence
    end
  end

  def mark_as_completed
    @purchase.mark_as_completed!
    
    redirect_to purchases_path
  end

  def mark_as_cancelled
    @purchase.mark_as_cancelled!
    
    redirect_to purchases_path
  end

  private

  def purchase_params
    params
      .require(:purchase)
      .permit(
        purchase_items_attributes: [
          :id,
          :quantity,
          :shop_item_id,
          :_destroy
        ]
      )
  end

  def find_purchase
    @purchase = Purchase.find params[:id]
  rescue ActiveRecord::RecordNotFound => err
    redirect_to(root_path, alert: err.message) and return
  end
end
class PurchasesController < ApplicationController
  before_action only: %i[new create] do
    @purchase = Purchase.new
  end

  before_action :find_purchase, only: %i[update show destroy]

  def index
    @purchses = Purchase.all
  end

  def 

  def create
    if @purchase.save!
      redirect_to purchase_path @purchase
    else
      redirect_to root_path, alert: @purchase.errors.full_messages.to_sentence
    end
  end

  def show
  end

  def update
    if @purchase.update(purchase_params)
      redirect_to purchase_path @purchase
    else
      redirect_to root_path, alert: @purchase.errors.full_messages.to_sentence
    end
  end

  def destroy
    @purchase.mark_as_cancelled!
  end


  private

  def purchase_params
    params
      .require(:purchase)
      .permit(
        purchase_item_attributes: [
          :id,
          :quantity
        ]
      )
  end

  def find_purchase
    @purcase = Purchase.find params[:id]
  rescue ActiveRecord::RecordNotFound => err
    redirect_to(root_path, alert: err.message) and return
  end
end
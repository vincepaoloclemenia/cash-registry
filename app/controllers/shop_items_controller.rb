class ShopItemsController < ApplicationController
  def index
    @shop_items = ShopItem.all
  end
end
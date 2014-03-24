class ModsController < ApplicationController
  respond_to :json

  before_filter :find_item_type

  def index
    @mods = @item_type.mods
    respond_with @mods
  end

  private

  def find_item_type
    @item_type = ItemType.find_by!(name: params[:item_type_id])
  end
end

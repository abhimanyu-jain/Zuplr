class ItemStatusesController < ApplicationController
    
  #View all item_statuss
  def index
    @item_status = ItemStatus.all
  end
  
  #New item_status page
  def new
  end

  #Create new item_status
  def create
    @item_status = ItemStatus.new(item_status_params)
    @item_status.save
    redirect_to item_statuses_path
  end
  
  #See specific item_status
  def show
    @item_status = ItemStatus.find(params[:id])
  end
  
  private
  def item_status_params
    params.require(:item_status).permit(:name)
  end

end

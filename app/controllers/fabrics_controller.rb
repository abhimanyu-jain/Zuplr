class FabricsController < ApplicationController
    
  #View all fabrics
  def index
    @fabrics = Fabric.all
  end
  
  #New fabric page
  def new
  end

  #Create new fabric
  def create
    @fabric = Fabric.new(fabric_params)
    @fabric.save
    redirect_to fabrics_path
  end
  
  #See specific fabric
  def show
    @fabric = Fabric.find(params[:id])
  end
  
  private
  def fabric_params
    params.require(:fabric).permit(:name)
  end
end

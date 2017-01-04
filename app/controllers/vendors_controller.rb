class VendorsController < ApplicationController
  before_action :authenticate_admin
  
  #View all vendors
  def index
    @vendors = Vendor.all
  end
  
  #New Vendor page
  def new
  end

  #Create new vendor
  def create
    @vendor = Vendor.new(vendor_params)
    @vendor.save
    redirect_to vendors_path
  end
  
  #See specific vendor
  def show
    @vendor = Vendor.find(params[:id])
  end
  
  private
  def vendor_params
    params.require(:vendor).permit(:name)
  end
end

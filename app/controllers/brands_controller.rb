class BrandsController < ApplicationController
  before_action :authenticate_admin
  
  #View all Brands
  def index
    @brands = Brand.all
  end
  
  #New Brand page
  def new
  end

  #Create new Brand
  def create
    @brand = Brand.new(brand_params)
    @brand.save
    redirect_to brands_path
  end
  
  #See specific Brand
  def show
    @brand = Brand.find(params[:id])
  end
  
  private
  def brand_params
    params.require(:brand).permit(:name)
  end
end

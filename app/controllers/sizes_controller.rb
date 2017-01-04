class SizesController < ApplicationController
  
  before_action :authenticate_admin
  
  #View all Sizes
  def index
    @sizes = Size.all
  end

  #New Size page
  def new
  end

  #Create new vendor
  def create
    @size = Size.new(size_params)
    @size.save
    redirect_to sizes_path
  end

  #See specific vendor
  def show
    @size = Size.find(params[:id])
  end

  private

  def size_params
    params.require(:size).permit(:value)
  end

end

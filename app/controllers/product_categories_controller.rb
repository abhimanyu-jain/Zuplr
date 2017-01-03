class ProductCategoriesController < ApplicationController
      
  #View all product_categories
  def index
    @product_categories = ProductCategory.all
  end
  
  #New product_category page
  def new
  end

  #Create new product_category
  def create
    @product_category = ProductCategory.new(product_category_params)
    @product_category.save
    redirect_to product_categories_path
  end
  
  #See specific product_category
  def show
    @product_categori = ProductCategory.find(params[:id])
  end
  
  private
  def product_category_params
    params.require(:product_category).permit(:name)
  end

end

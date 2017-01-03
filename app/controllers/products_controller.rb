class ProductsController < ApplicationController
  #View all products
  def index

    #Conditional chaining (put your methods into an arry and then execute everything in this array, depending on what parameters have been selected)
    #arr = []
    #arr << where("variants.size_id" => "1")
    #binding.pry

    @items = Product.select(
    'products.title, products.description, products.pattern,
    products.product_category_id, products.fabric_id, products.vendor_id, products.brand_id,
    variants.id, variants.created_at, variants.updated_at, variants.color, variants.cost_price, variants.purchase_date,
    variants.size_id,
    sizes.value as size,
    item_statuses.name as status,
    fabrics.name as fabric,
    vendors.name as vendor,
    brands.name as brand,
    product_categories.name as category'
    )
    .joins("LEFT JOIN variants on products.id = variants.product_id")
    .joins("LEFT JOIN sizes on variants.size_id = sizes.id")
    .joins("LEFT JOIN item_statuses on variants.item_status_id = item_statuses.id")
    .joins("LEFT JOIN fabrics on products.fabric_id = fabrics.id")
    .joins("LEFT JOIN vendors on products.vendor_id = vendors.id")
    .joins("LEFT JOIN brands on products.brand_id = brands.id")
    .joins("LEFT JOIN product_categories on products.product_category_id = product_categories.id")

    if params[:product]
      @category_id = params[:product][:product_category_id]
      @fabric_id = params[:product][:fabric_id]
      @vendor_id = params[:product][:vendor_id]
      @brand_id = params[:product][:brand_id]
      @item_status_id = params[:product][:item_status_id]
      @size_id = params[:product][:size_id]
      @color = params[:product][:color]
      @pattern = params[:product][:pattern]
      if params[:product][:purchase_date] != ''
        @purchase_date = Date.strptime(params[:product][:purchase_date], "%m/%d/%Y")
      end

      if(@category_id != nil && @category_id != "")
        @items = @items.where('products.product_category_id' => @category_id)
      end

      if(@fabric_id != nil && @fabric_id != "")
        @items = @items.where('products.fabric_id' => @fabric_id)
      end

      if(@vendor_id != nil && @vendor_id != "")
        @items = @items.where('products.vendor_id' => @vendor_id)
      end

      if(@brand_id != nil && @brand_id != "")
        @items = @items.where('products.brand_id' => @brand_id)
      end

      if(@item_status_id != nil && @item_status_id != "")
        @items = @items.where('variants.item_status_id' => @item_status_id)
      end

      if(@size_id != nil && @size_id != "")
        @items = @items.where('variants.size_id' => @size_id)
      end

      if(@color != nil && @color != "")
        @items = @items.where('variants.color' => @color)
      end

      if(@pattern != nil && @pattern != "")
        @items = @items.where('products.pattern' => @pattern)
      end

      if(@purchase_date != nil && @purchase_date != "")
        @items = @items.where('variants.purchase_date' => @purchase_date)
      end

    end

  end

  #New product page
  def new
  end

  #Create new product
  def create
    @product = Product.new(product_params)
    @product.save
    binding.pry
    variants = params[:product][:variants]
    variants.each do |v|
      v[:purchase_date] = Date.strptime(v[:purchase_date], "%m/%d/%Y")
      variant = Variant.new(variant_params(v))
      variant.product = @product
      variant.save
    end
    redirect_to products_path
  end

  #See specific product
  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :product_category_id, :fabric_id, :pattern, :vendor_id, :brand_id)
  end

  def variant_params(variant)
    variant.permit(:size_id, :color, :item_status_id, :cost_price, :purchase_date)
  end

end

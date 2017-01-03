class Product < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :fabric
  belongs_to :vendor
  belongs_to :brand
  has_many :variants
  accepts_nested_attributes_for :variants
end

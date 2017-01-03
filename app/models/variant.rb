class Variant < ActiveRecord::Base
  belongs_to :product
  belongs_to :size
  belongs_to :item_status
end

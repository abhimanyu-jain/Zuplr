class AddPromoCodeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :promo_code, :string
  end
end

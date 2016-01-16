class AddPincodeToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :pincode, :integer
  end
end

class AddSessionNumberToDeliveries < ActiveRecord::Migration
  def change
    add_column :deliveries, :session_number, :string
  end
end

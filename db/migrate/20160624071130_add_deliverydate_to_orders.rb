class AddDeliverydateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :scheduleddeliverydate, :date
  end
end

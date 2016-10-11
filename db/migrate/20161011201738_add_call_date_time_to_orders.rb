class AddCallDateTimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :call_date_time, :datetime
  end
end

class AddOrderToContactLog < ActiveRecord::Migration
  def change
    add_reference :contact_logs, :order, index: true, foreign_key: true
  end
end

class AddAssignedStylistIdToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :stylist, references: :users, index: true
    add_foreign_key :orders, :users, column: :stylist_id
  end
end

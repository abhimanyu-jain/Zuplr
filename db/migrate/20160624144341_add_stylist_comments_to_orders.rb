class AddStylistCommentsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stylist_comments, :text
  end
end

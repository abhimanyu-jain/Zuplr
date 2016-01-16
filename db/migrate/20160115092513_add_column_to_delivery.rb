class AddColumnToDelivery < ActiveRecord::Migration
  def change
    add_column :deliveries, :userid, :integer
  end
end

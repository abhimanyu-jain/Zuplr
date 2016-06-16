class AddUserAndStatusToDeliveries < ActiveRecord::Migration
  def change
    add_reference :deliveries, :user, index: true, foreign_key: true
    add_column :deliveries, :status, :string
  end
end

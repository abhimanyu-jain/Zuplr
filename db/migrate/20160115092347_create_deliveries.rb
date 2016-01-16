class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :phonenumber, :limit => 8
      t.datetime :delivery_date

      t.timestamps null: false
    end
  end
end

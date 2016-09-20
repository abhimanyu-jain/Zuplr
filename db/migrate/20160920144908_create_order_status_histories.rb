class CreateOrderStatusHistories < ActiveRecord::Migration
  def change
    create_table :order_status_histories do |t|
      t.references :order, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end

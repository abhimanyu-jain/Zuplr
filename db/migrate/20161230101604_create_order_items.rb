class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true, foreign_key: true
      t.references :variant, index: true, foreign_key: true
      t.integer :selling_price
      t.string :size_feedback
      t.string :style_feedback
      t.string :price_feedback
      t.string :fit_cut_feedback
      t.integer :kept
      t.text :customer_comments

      t.timestamps null: false
    end
  end
end

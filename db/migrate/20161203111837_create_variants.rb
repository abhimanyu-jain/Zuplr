class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product, index: true, foreign_key: true
      t.references :size, index: true, foreign_key: true
      t.string :color
      t.references :item_status, index: true, foreign_key: true
      t.integer :cost_price
      t.date :purchase_date

      t.timestamps null: false
    end
  end
end

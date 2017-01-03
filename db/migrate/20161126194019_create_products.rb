class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.references :product_category, index: true, foreign_key: true
      t.references :fabric, index: true, foreign_key: true
      t.string :pattern
      t.references :vendor, index: true, foreign_key: true
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

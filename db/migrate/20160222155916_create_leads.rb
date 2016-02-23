class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :name
      t.integer :phonenumber, :limit => 8
      t.string :city

      t.timestamps null: false
    end
  end
end

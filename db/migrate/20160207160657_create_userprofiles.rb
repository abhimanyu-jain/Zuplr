class CreateUserprofiles < ActiveRecord::Migration
  def change
    create_table :userprofiles do |t|
      t.text :data
      t.string :city
      t.integer :phonenumber, :limit => 8

      t.timestamps null: false
    end
  end
end

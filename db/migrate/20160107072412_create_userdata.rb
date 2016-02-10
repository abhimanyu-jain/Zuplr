class CreateUserdata < ActiveRecord::Migration
  def change
    create_table :userdata do |t|
      t.text :data

      t.timestamps null: false
    end
  end
end

class AddCityToUserdata < ActiveRecord::Migration
  def change
    add_column :userdata, :city, :string
  end
end

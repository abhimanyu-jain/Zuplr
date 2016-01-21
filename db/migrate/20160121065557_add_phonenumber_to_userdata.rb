class AddPhonenumberToUserdata < ActiveRecord::Migration
  def change
    add_column :userdata, :phonenumber, :integer, :limit => 8
  end
end

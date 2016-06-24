class AddAddressToUserprofiles < ActiveRecord::Migration
  def change
    add_column :userprofiles, :address, :string
  end
end

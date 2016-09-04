class AddPincodeToUserprofiles < ActiveRecord::Migration
  def change
    add_column :userprofiles, :pincode, :integer
  end
end

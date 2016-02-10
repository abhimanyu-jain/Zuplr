class AddNameToUserprofile < ActiveRecord::Migration
  def change
    add_column :userprofiles, :name, :string
  end
end

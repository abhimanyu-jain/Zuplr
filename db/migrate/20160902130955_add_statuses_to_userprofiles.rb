class AddStatusesToUserprofiles < ActiveRecord::Migration
  def change
    add_column :userprofiles, :phone_number_status, :string
    add_column :userprofiles, :gender, :string
    add_column :userprofiles, :latest_status, :string
  end
end

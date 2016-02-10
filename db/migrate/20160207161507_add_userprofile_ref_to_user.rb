class AddUserprofileRefToUser < ActiveRecord::Migration
  def change
    add_reference :users, :userprofile, index: true, foreign_key: true
  end
end

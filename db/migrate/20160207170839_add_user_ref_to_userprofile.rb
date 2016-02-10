class AddUserRefToUserprofile < ActiveRecord::Migration
  def change
    add_reference :userprofiles, :user, index: true, foreign_key: true
  end
end

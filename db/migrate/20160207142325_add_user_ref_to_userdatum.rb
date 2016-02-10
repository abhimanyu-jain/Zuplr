class AddUserRefToUserdatum < ActiveRecord::Migration
  def change
    add_reference :userdata, :user, index: true, foreign_key: true
  end
end

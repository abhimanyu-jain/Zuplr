class AddUserdatumRefToUser < ActiveRecord::Migration
  def change
    add_reference :users, :userdatum, index: true, foreign_key: true
  end
end

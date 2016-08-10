class AddStylistCommentToUserprofiles < ActiveRecord::Migration
  def change
    add_column :userprofiles, :stylist_comment, :text
  end
end

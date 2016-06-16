class AddCreditsToUserprofiles < ActiveRecord::Migration
  def change
    add_column :userprofiles, :credits, :integer, :default => 0
  end
end

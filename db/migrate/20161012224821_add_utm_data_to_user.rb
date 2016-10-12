class AddUtmDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :utm_source, :string
    add_column :users, :utm_campaign, :string
    add_column :users, :utm_medium, :string
  end
end

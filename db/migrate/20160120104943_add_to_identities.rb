class AddToIdentities < ActiveRecord::Migration
  def change
  	add_column :identities, :mail_sent, :boolean, default: false
  end
end

class CreateContactLogs < ActiveRecord::Migration
  def change
    create_table :contact_logs do |t|
      t.datetime :contact_date
      t.text :notes

      t.timestamps null: false
    end
  end
end

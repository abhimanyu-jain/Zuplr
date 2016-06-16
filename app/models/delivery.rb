class Delivery < ActiveRecord::Base
	belongs_to :user
	enum status: [ :created, :archived ]
end

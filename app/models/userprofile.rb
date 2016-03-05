class Userprofile < ActiveRecord::Base
	has_one :user, :dependent => :destroy
  validates_presence_of :city, :phonenumber
end

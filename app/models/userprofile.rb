class Userprofile < ActiveRecord::Base
	has_one :user, :dependent => :destroy
  validates_presence_of :city, :phonenumber
  # validates_format_of :phonenumber, :with => /((\+*)((0[ -]+)*|(91 )*)(\d{12}+|\d{10}+))|\d{5}([- ]*)\d{6}/
end

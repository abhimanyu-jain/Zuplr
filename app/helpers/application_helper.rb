module ApplicationHelper
	def check_user_data(id)
		defined?Userprofile.find_by_user_id(id).phonenumber
	end
end

class Attending < ActiveRecord::Base
	has_many :sessions
	
	def to_label
		"#{last_name}, #{first_name}"
	end
end

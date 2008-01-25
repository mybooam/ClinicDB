class User < ActiveRecord::Base
	has_many :visits
	has_many :tb_tests
	
	def to_label
		"#{last_name}, #{first_name}"
	end
end

class User < ActiveRecord::Base
	has_many :visits
	has_many :tb_tests
	
	def to_label
		"#{first_name} #{last_name}"
	end
end

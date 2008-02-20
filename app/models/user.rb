class User < ActiveRecord::Base
	has_and_belongs_to_many :visits
	has_many :tb_tests_given, {:foreign_key => 'givenby_user_id', :class_name => 'TBTest'}
	has_many :tb_tests_read, {:foreign_key => 'readby_user_id', :class_name => 'TBTest'}
	
	def to_label
		"#{first_name} #{last_name}"
	end
end

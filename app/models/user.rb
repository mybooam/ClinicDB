class User < ActiveRecord::Base
	has_and_belongs_to_many :visits
	has_many :given_tb_tests, :class_name => "TbTest", :foreign_key => "givenby_user_id"
	has_many :read_tb_tests, :class_name => "TbTest", :foreign_key => "readby_user_id"
	
	def to_label
		"#{first_name} #{last_name}"
	end
end

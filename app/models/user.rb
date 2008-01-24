class User < ActiveRecord::Base
	has_many :visits
	has_many :tb_tests
end

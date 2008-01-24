class Attending < ActiveRecord::Base
	has_many :sessions
end

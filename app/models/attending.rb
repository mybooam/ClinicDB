class Attending < ActiveRecord::Base
	has_many :sessions
	
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_uniqueness_of :email
	
	def to_label
		"#{last_name}, #{first_name}"
	end
end

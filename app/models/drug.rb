class Drug < ActiveRecord::Base
	has_many :prescriptions
	
	def to_label
		"#{name}"
	end
end

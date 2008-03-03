class Drug < ActiveRecord::Base
	has_many :prescriptions
	
	def to_label
		"#{name}"
	end
	
	def to_s
	  to_label
  end
end

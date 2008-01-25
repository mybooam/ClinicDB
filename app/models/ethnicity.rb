class Ethnicity < ActiveRecord::Base
	has_many :patients
	
	def to_label
		"#{name}"
	end
end

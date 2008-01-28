class Ethnicity < ActiveRecord::Base
	has_many :patients
	
	def to_label
		"#{name}"
	end
	
	def to_s
	  to_label
  end
end

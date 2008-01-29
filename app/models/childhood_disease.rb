class ChildhoodDisease < ActiveRecord::Base
	has_and_belongs_to_many :patients
	
	def to_label
		"#{name}"
	end
	
	def to_s
	  "#{name}"
  end
end

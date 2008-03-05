class Ethnicity < ActiveRecord::Base
	has_many :patients
	
	validates_presence_of :name
	validates_uniqueness_of :name
	
	def to_label
		"#{name}"
	end
	
	def to_s
	  to_label
  end
end

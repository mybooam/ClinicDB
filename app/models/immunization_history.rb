class ImmunizationHistory < ActiveRecord::Base
	has_and_belongs_to_many :patients
	
	validates_presence_of :name
	validates_uniqueness_of :name
	
	def to_label
		"#{name}"
	end

	def to_s
	  "#{name}"
  end
end

class ImmunizationDrug < ActiveRecord::Base
	has_many :immunizations
	
	validates_presence_of :name
	validates_uniqueness_of :name
	
	def to_label
		"#{name}"
	end

	def to_s
	  "#{name}"
  end
end

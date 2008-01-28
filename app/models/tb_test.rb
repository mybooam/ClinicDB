class TbTest < ActiveRecord::Base
	belongs_to :patient
	
	def to_label
		"#{patient.to_label} TB Test"
	end
end

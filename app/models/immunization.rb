class Immunization < ActiveRecord::Base
	belongs_to :patient
	belongs_to :immunization_drug
	
	def to_label
		"#{immunization_drug.name} #{visit.session.session_date}"
	end
end

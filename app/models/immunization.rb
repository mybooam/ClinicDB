class Immunization < ActiveRecord::Base
	belongs_to :patient
	belongs_to :immunization_drug
	
	validates_presence_of :immunization_drug_id
	validates_presence_of :given_date
	validates_presence_of :patient_id
	
	def to_label
		"#{immunization_drug.name} #{given_date}"
	end
end

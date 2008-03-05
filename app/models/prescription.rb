class Prescription < ActiveRecord::Base
	belongs_to :patient
	belongs_to :drug
	
	validates_presence_of :drug_id
	validates_presence_of :signed
	validates_presence_of :patient_id
	
	def to_label
		"#{drug.name} - #{orders}"
	end
end

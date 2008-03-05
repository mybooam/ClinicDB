class Visit < ActiveRecord::Base
	belongs_to :patient
	has_and_belongs_to_many :users
	
	validates_presence_of :patient_id
	validates_presence_of :visit_id
	
	def to_label
		"#{patient.to_label} seen #{visit_date}"
	end
end

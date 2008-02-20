class Visit < ActiveRecord::Base
	belongs_to :patient
	has_and_belongs_to_many :users
	
	def to_label
		"#{patient.to_label} seen #{visit_date}"
	end
end

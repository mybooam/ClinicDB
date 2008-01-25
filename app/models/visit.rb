class Visit < ActiveRecord::Base
	belongs_to :session
	belongs_to :patient
	has_and_belongs_to_many :users
	has_many :prescriptions
	
	def to_label
		"#{patient.to_label} seen #{session.session_date}"
	end
end

class Immunization < ActiveRecord::Base
	belongs_to :patient
	belongs_to :immunization_drug
	belongs_to :givenby_user, {:class_name => 'User', :foreign_key => 'givenby_user_id'}
	
	validates_presence_of :immunization_drug_id
	validates_presence_of :given_date
	validates_presence_of :patient_id
	validates_presence_of :givenby_user
	
	def to_label
		"#{immunization_drug.name} #{given_date}"
	end
end

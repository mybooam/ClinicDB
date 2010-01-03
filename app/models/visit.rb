class Visit < ActiveRecord::Base
	belongs_to :patient
	has_and_belongs_to_many :users
	
	validates_presence_of :patient_id
	
	before_save      EncryptionWrapper.new(["chief_complaint","referrals","subjective_note","objective_note","assessment_note","plan_note"])
  after_save       EncryptionWrapper.new(["chief_complaint","referrals","subjective_note","objective_note","assessment_note","plan_note"])
  after_find       EncryptionWrapper.new(["chief_complaint","referrals","subjective_note","objective_note","assessment_note","plan_note"])
  after_initialize EncryptionWrapper.new(["chief_complaint","referrals","subjective_note","objective_note","assessment_note","plan_note"])
	
	def after_find
  end
  
	def to_label
		"#{patient.to_label} seen #{visit_date}"
	end
end

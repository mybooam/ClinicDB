class PrescriptionEntry < ActiveRecord::Base
	belongs_to :prescription_choice
	belongs_to :visit
end

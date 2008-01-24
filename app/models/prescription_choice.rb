class PrescriptionChoice < ActiveRecord::Base
	has_many :prescription_entries
end

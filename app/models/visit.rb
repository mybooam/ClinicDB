class Visit < ActiveRecord::Base
	belongs_to :session
	belongs_to :patient
	has_many :prescription_entries
end

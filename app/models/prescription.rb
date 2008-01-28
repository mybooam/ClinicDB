class Prescription < ActiveRecord::Base
	belongs_to :patient
	belongs_to :drug
	
	def to_label
		"#{drug.name} - #{quantity} #{drug}"
	end
end

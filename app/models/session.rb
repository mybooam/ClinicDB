class Session < ActiveRecord::Base
	belongs_to :attending
	has_many :visits
	
	def to_label
		"#{session_date}"
	end
end

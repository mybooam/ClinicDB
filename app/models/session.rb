class Session < ActiveRecord::Base
	belongs_to :attending
	
	def to_label
		"#{session_date}"
	end
end

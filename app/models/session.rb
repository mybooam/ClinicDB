class Session < ActiveRecord::Base
	belongs_to :attending
	
	validates_uniqueness_of :session_date
	validates_presence_of :attending_id
	
	def to_label
		"#{session_date}"
	end
end

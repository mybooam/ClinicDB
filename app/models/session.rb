class Session < ActiveRecord::Base
	belongs_to :attending
	
	validates_presence_of :session_date
	validates_presence_of :attending_id
	
	validates_uniqueness_of :session_date
	
	def to_label
		"#{session_date} - #{attending.to_label}"
	end
end

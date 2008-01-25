class TbTest < ActiveRecord::Base
	belongs_to :patient
	belongs_to :user, :foreign_key => "givenby_user_id"
	belongs_to :user, :foreign_key => "readby_user_id"
	
	def to_label
		"#{patient.to_label} TB Test"
	end
end

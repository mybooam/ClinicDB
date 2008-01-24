class Session < ActiveRecord::Base
	belongs_to :attending
	has_many :visits
end

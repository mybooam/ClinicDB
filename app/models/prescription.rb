class Prescription < ActiveRecord::Base
	belongs_to :visit
	belongs_to :drug
end

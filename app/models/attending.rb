class Attending < ActiveRecord::Base
	has_many :sessions
	
	validates_presence_of :first_name
	validates_presence_of :last_name
	
	before_save      EncryptionWrapper.new(["first_name","last_name","email"])
  after_save       EncryptionWrapper.new(["first_name","last_name","email"])
  after_find       EncryptionWrapper.new(["first_name","last_name","email"])
  after_initialize EncryptionWrapper.new(["first_name","last_name","email"])
	
  def after_find
  end
  
	def to_label
		"#{last_name}, #{first_name}"
	end
end

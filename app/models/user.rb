class User < ActiveRecord::Base
	has_and_belongs_to_many :visits
	has_many :tb_tests_given, {:foreign_key => 'givenby_user_id', :class_name => 'TbTest'}
	has_many :tb_tests_read, {:foreign_key => 'readby_user_id', :class_name => 'TbTest'}
	has_many :immunizations_given, {:foreign_key => 'givenby_user_id', :class_name => 'Immunization'}
	
	validates_presence_of :first_name
	validates_presence_of :last_name
	
	before_save      EncryptionWrapper.new(["first_name","last_name","email"])
  after_save       EncryptionWrapper.new(["first_name","last_name","email"])
  after_find       EncryptionWrapper.new(["first_name","last_name","email"])
  after_initialize EncryptionWrapper.new(["first_name","last_name","email"])
	
	def to_label
		"#{first_name} #{last_name}"
	end
	
	def isLinked?
	  !(visits.empty? && tb_tests_given.empty? && tb_tests_read.empty? && immunizations_given.empty?)
  end
  
  def tb_tests
    (tb_tests_given + tb_tests_read).uniq
  end
end

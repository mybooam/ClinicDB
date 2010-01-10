class User < ActiveRecord::Base
	has_and_belongs_to_many :visits
	has_many :tb_tests_given, {:foreign_key => 'givenby_user_id', :class_name => 'TbTest'}
	has_many :tb_tests_read, {:foreign_key => 'readby_user_id', :class_name => 'TbTest'}
	has_many :immunizations_given, {:foreign_key => 'givenby_user_id', :class_name => 'Immunization'}
	
	validates_presence_of :first_name
	validates_presence_of :last_name
  validates_uniqueness_of :email
  validates_uniqueness_of :access_hash
	
	before_save      EncryptionWrapper.new(["first_name","last_name","email","access_hash"])
  after_save       EncryptionWrapper.new(["first_name","last_name","email","access_hash"])
  after_find       EncryptionWrapper.new(["first_name","last_name","email","access_hash"])
  after_initialize EncryptionWrapper.new(["first_name","last_name","email","access_hash"])
  
  def after_find
  end
	
	def to_label 
		"#{first_name} #{last_name}"
	end
	
	def isLinked?
	  !(visits.empty? && tb_tests_given.empty? && tb_tests_read.empty? && immunizations_given.empty?)
  end
  
  def tb_tests
    (tb_tests_given + tb_tests_read).uniq
  end
  
  def self.hash_access_code(code)
    hex_array2str(Digest::SHA256.digest(code))
  end
  
  def self.by_access_code(code)
    tr = nil
    res = User.find(:all, :conditions => "access_hash = '#{hash_access_code(code)}' OR access_hash = '#_#{encrypt_string(hash_access_code(code))}'")
    if(res.length>0)
      tr = res[0]
    end
    tr
  end
end

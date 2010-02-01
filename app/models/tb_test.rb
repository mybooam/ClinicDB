class TbTest < ActiveRecord::Base
	belongs_to :patient
	belongs_to :givenby_user, {:class_name => 'User', :foreign_key => 'givenby_user_id'}
	belongs_to :readby_user, {:class_name => 'User', :foreign_key => 'readby_user_id'}
	
	validates_presence_of :patient_id
	validates_presence_of :givenby_user
	validates_presence_of :given_date
	
	before_save      EncryptionWrapper.new(["lot_number","given_arm","result"])
  after_save       EncryptionWrapper.new(["lot_number","given_arm","result"])
  after_find       EncryptionWrapper.new(["lot_number","given_arm","result"])
  after_initialize EncryptionWrapper.new(["lot_number","given_arm","result"])
  
  def after_find
    
  end
  
	def to_label
		"#{patient.to_label} TB Test"
	end
	
	def read
	  (result != nil && result != "")
  end
  
  def due_date_min
    given_date + Setting.get_f("tb_test_read_start", 2)
  end
  
  def due_date_max
    given_date + Setting.get_f("tb_test_read_end", 3)
  end
  
  def ready_to_be_read
    !read && Date.today>=due_date_min && Date.today<=due_date_max
  end
  
  def overdue
    Date.today > due_date_max && !read
  end
  
  def coming_due?
    Date.today < due_date_min
  end
  
  def open
    ready_to_be_read || overdue || coming_due?
  end
  
  def positive?
    result == positive_result
  end
  
  def negative?
    result == negative_result
  end
  
  def unknown?
    result == unknown_result
  end
  
  def noshow?
    result == noshow_result
  end
  
  def noshow_result
    "No-Show"
  end
  
  def positive_result
    "Positive"
  end
  
  def negative_result
    "Negative"
  end
  
  def unknown_result
    "Unknown"
  end
end

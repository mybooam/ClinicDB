class TbTest < ActiveRecord::Base
	belongs_to :patient
	
	def to_label
		"#{patient.to_label} TB Test"
	end
	
	def read
	  (result != nil && result != "")
  end
  
  def due_date_min
    given_date + 2
  end
  
  def due_date_max
    given_date + 3
  end
  
  def ready_to_be_read
    !read && Date.today>=due_date_min && Date.today<=due_date_max
  end
  
  def overdue
    Date.today > due_date_max && !read
  end
  
  def open
    ready_to_be_read || overdue
  end
end

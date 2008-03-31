class Session < ActiveRecord::Base
	belongs_to :attending
	
	validates_presence_of :session_date
	validates_presence_of :attending_id
	
	validates_uniqueness_of :session_date
	
	def to_label
		"#{session_date} - #{attending.to_label}"
	end
	
	def self.todayNeedsOne?
	  Session.find(:all).select{|a| a.session_date==Date.today()}.empty? && Date.today.strftime("%a").downcase=="sat"
  end
  
  def self.getToday
    sess = Session.find(:all).select{|a| a.session_date==Date.today()}
    if !sess.empty?
      sess[0]
    else
      nil
    end
  end
end

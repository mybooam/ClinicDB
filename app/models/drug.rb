class Drug < ActiveRecord::Base
	has_many :prescriptions
	
	validates_presence_of :name
	validates_uniqueness_of :name
	
	def to_label
	  if has_dose_unit
		  "#{drug_name} - #{dose_unit}"
	  else
	    drug_name
    end
	end
	
	def to_s
	  to_label
  end
  
  #need to write unit tests for these
  #i am sure there is a better way to handle this
  
  def drug_name
    has_dose_unit ? name.split("|")[0].strip : name
  end
  
  def dose_unit
    has_dose_unit ? name.split("|")[1].strip : ""
  end
  
  def has_dose_unit
    if name.count("|") == 0
      false
    end
    
    name.split("|").select{|a| a.strip != ""}.length>1
  end
  
  # needs unit tests
  def self.from_user_string(str)
    m = str.strip.match(/[- \|]+[0-9]+.*/)
    if(m==nil)
      Drug.new(:name => str.strip)
    else
      start = m.pre_match.strip
      ending = m.to_a.join.match(/[0-9]+.*/).to_a.join.strip + m.post_match.strip
      ending = ending.split(" ").join
      Drug.new(:name => "#{start}|#{ending}".strip)
    end
  end
end

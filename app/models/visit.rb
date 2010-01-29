class Visit < ActiveRecord::Base
	belongs_to :patient
	has_and_belongs_to_many :users
  
  belongs_to :pharmacy
  belongs_to :marital_status
  belongs_to :living_arrangement
  belongs_to :education_level
	
	validates_presence_of :patient_id
	
	before_save      EncryptionWrapper.new( Visit.columns.select{ |c| c.text? && c.name!='version' }.collect{ |c| c.name })
  after_save       EncryptionWrapper.new( Visit.columns.select{ |c| c.text? && c.name!='version' }.collect{ |c| c.name })
  after_find       EncryptionWrapper.new( Visit.columns.select{ |c| c.text? && c.name!='version' }.collect{ |c| c.name })
  after_initialize EncryptionWrapper.new( Visit.columns.select{ |c| c.text? && c.name!='version' }.collect{ |c| c.name })
	
	def after_find
  end
  
	def to_label
		"#{patient.to_label} seen #{visit_date}"
  end

  def self.current_version
    #"soap"
    "hpi_auto"
  end
end

class Visit < ActiveRecord::Base
  Visit::ValidVersions = %w(soap hpi_auto bp_check procedure quick_note)
  
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
  
  before_destroy {|visit| 
    visit.users.clear
    VisitIdentifier.delete_for_visit(visit)
  }
	
	def after_find
  end
  
  def visit_number
    VisitIdentifier.get_or_create_for_visit(self).identifier
  end
  
	def to_label
		"#{patient.to_label} seen #{visit_date}"
  end

  def self.current_version
    #"soap"
    "hpi_auto"
  end
  
  def self.new_or_update_from_params(params)
    visit = params[:visit_id] ? Visit.update(params[:visit_id][:visit_id], params[:visit]) : Visit.new(params[:visit])
    
    visit.visit_date = Date.today unless visit.visit_date
    
    if(visit.temperature)
      if(visit.temperature < 50)
        visit.temperature = visit.temperature * 1.8 + 32
      end
    end
    visit.users = []
    
    if params[:users_id1] && params[:users_id1]!=""
      visit.users << User.find(params[:users_id1])
    end
    if params[:users_id2] && params[:users_id2]!=""
      visit.users << User.find(params[:users_id2])
    end
    
    if visit.save
      visit
    else
      nil
    end
  end
end

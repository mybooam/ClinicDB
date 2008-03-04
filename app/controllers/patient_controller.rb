class PatientController < ApplicationController
	active_scaffold :patient do |config|
		config.columns = [:first_name, :last_name, :dob, :sex, :ethnicity, :history_taken, :curr_smoking, :prev_smoking, :smoking_py, :curr_etoh_use, :prev_etoh_use, :etoh_notes, :curr_drug_use, :prev_drug_use, :drug_notes, :adult_illness, :surgeries, :allergies, :immunization_histories, :childhood_diseases, :family_histories]
		
		config.list.columns = [:last_name, :first_name, :dob, :sex, :ethnicity, :history_taken]
		
		config.columns[:history_taken].form_ui = :checkbox
		
		config.columns[:dob].form_ui = :textarea
		config.columns[:dob].options[:cols] = 10
		config.columns[:dob].options[:rows] = 1
		
		config.columns[:ethnicity].form_ui = :select
		config.columns[:curr_smoking].form_ui = :checkbox
		config.columns[:prev_smoking].form_ui = :checkbox
		config.columns[:curr_etoh_use].form_ui = :checkbox
		config.columns[:prev_etoh_use].form_ui = :checkbox
		config.columns[:curr_drug_use].form_ui = :checkbox
		config.columns[:prev_drug_use].form_ui = :checkbox
		
		config.columns[:immunization_histories].form_ui = :select
		config.columns[:childhood_diseases].form_ui = :select
		config.columns[:family_histories].form_ui = :select
	end
	
	def live_search
	    max_listing = 15
      post_sections = request.raw_post.split('&')
      if(post_sections.length>1)
        phrases = post_sections[0].split('%20')
      
        query_any = phrases.collect { |a|
          "(first_name LIKE '%#{a}%' OR last_name LIKE '%#{a}%' OR dob LIKE '%#{a}%')"
        }.join(" OR ")
        
        query_all = phrases.collect { |a|
          "(first_name LIKE '%#{a}%' OR last_name LIKE '%#{a}%' OR dob LIKE '%#{a}%')"
        }.join(" AND ")
      
        @results_all = Patient.find(:all, :conditions => query_all).sort{|a, b| a.to_label <=> b.to_label}
        @results_any = Patient.find(:all, :conditions => query_any).sort{|a, b| a.to_label <=> b.to_label}
        
        @results = (@results_all + @results_any).uniq
      end  

      render(:layout => false)
  end
  
  def add_history
    Patient.update(params[:patient_id][:patient_id], params[:patient])
    
    pat = Patient.find(params[:patient_id][:patient_id])
    pat.history_taken = true;
    
    pat.childhood_diseases = params[:childhood_disease].delete_if {|k,v| v=='0'}.collect{|a| ChildhoodDisease.find(a[0])}
    pat.immunization_histories = params[:immunization_history].delete_if {|k,v| v=='0'}.collect{|a| ImmunizationHistory.find(a[0])}
    pat.family_histories = params[:family_history].delete_if {|k,v| v=='0'}.collect{|a| FamilyHistory.find(a[0])}
    
    pat.save
    
    redirect_to :controller => :home, :action => :patient_home, :patient_id => pat.id
  end
  
  def set_patient
    redirect_to :controller => 'home', :action => "patient_home", :patient_id => params[:patient_id]
  end
end

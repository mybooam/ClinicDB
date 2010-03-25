class PatientController < ApplicationController
	def add_patient
    pat = Patient.new(params[:patient])
    
    unless params[:patient][:dob] =~ /[0-9]{1,2}[- \/.][0-9]{1,2}[- \/.](19|20|)[0-9]{2}/
      flash[:error] = "Invalid date.  Please enter in the form mm/dd/yy.  For example: 7/22/68"
      redirect_to :back and return
    end
    
    begin
      pat.dob = Date.parse(params[:patient][:dob], true)
    rescue
      flash[:error] = "Invalid date.  Please enter in the form mm/dd/yy.  For example: 7/22/68"
      redirect_to :back and return
    end
    
    if pat.dob>Date.today()
      pat.dob = Date.civil(pat.dob.year-100, pat.dob.mon, pat.dob.mday)
    end
    
    pat.ethnicity = Ethnicity.find(params[:ethnicity])
    pat.history_taken = false

    if !Patient.find(:all).select{|a| a.to_label.downcase == pat.to_label.downcase }.empty?
      flash[:error] = "Patient already exists."
      redirect_to :back and return
    end

    if !Patient.find(:all).select{|a| a.name.downcase == pat.name.downcase }.empty?
      flash[:warning] = "Patient may already exists.  Check for repeated patient."
    end

    if pat.save 
      PatientIdentifier.give_identifier(pat)
      flash[:notice] = "#{pat.properLastName} was saved successfully"
      Transaction.log_create_patient(session[:user].id, pat.id)
      redirect_to :controller=>:home, :action => :patient_history_query, :patient_id => pat
    else
      flash[:error] = "Saving patient failed."
      redirect_to :back
    end
  end
  
  def add_history
    Patient.update(params[:patient_id][:patient_id], params[:patient])
    
    pat = Patient.find(params[:patient_id][:patient_id])
    pat.history_taken = true
    
    if params[:history][:smoking] == 'Current'
        pat.prev_smoking = true
        pat.curr_smoking = true
      elsif params[:history][:smoking] == 'Previous'
        pat.prev_smoking = true
        pat.curr_smoking = false
      else
        pat.prev_smoking = false
        pat.curr_smoking = false
      end
      
      if params[:history][:drug_use] == 'Current'
        pat.prev_drug_use = true
        pat.curr_drug_use = true
      elsif params[:history][:drug_use] == 'Previous'
        pat.prev_drug_use = true
        pat.curr_drug_use = false
      else
        pat.prev_drug_use = false
        pat.curr_drug_use = false
      end
      
      if params[:history][:etoh_use] == 'Current'
        pat.prev_etoh_use = true
        pat.curr_etoh_use = true
      elsif params[:history][:etoh_use] == 'Previous'
        pat.prev_etoh_use = true
        pat.curr_etoh_use = false
      else
        pat.prev_etoh_use = false
        pat.curr_etoh_use = false
      end
    
    pat.childhood_diseases = params[:childhood_disease].delete_if {|k,v| v=='0'}.collect{|a| ChildhoodDisease.find(a[0])}
    pat.immunization_histories = params[:immunization_history].delete_if {|k,v| v=='0'}.collect{|a| ImmunizationHistory.find(a[0])}
    pat.family_histories = params[:family_history].delete_if {|k,v| v=='0'}.collect{|a| FamilyHistory.find(a[0])}
    
    if pat.save
      flash[:notice] = "#{pat.properLastName}'s history added."
      Transaction.log_edit_patient(session[:user].id, pat.id)
      redirect_to :controller => :home, :action => :patient_home, :patient_id => pat.id
    else
      flash[:error] = "#{pat.properLastName}'s history could not be added."
      redirect_to :back
    end
  end
	
	def update_patient
	  Patient.update(params[:patient_id][:patient_id], params[:literal_update])
    
    pat = Patient.find(params[:patient_id][:patient_id])
    
#    puts "Patient date of birth: #{params[:patient][:dob]}"
   
   if params[:patient][:dob].match("[0-9]{1,2}[- /.][0-9]{1,2}[- /.](19|20|)[0-9]{2}").nil?
      flash[:error] = "Invalid date.  Please enter in the form mm/dd/yy.  For example: 7/22/68"
      redirect_to :back
      return
    end
    
    begin
      pat.dob = Date.parse(params[:patient][:dob], true)
    rescue
      flash[:error] = "Invalid date exception.  Please enter in the form mm/dd/yy.  For example: 7/22/68"
      redirect_to :back
      return
    end
    
    if pat.dob>Date.today()
      pat.dob = Date.civil(pat.dob.year-100, pat.dob.mon, pat.dob.mday)
    end
    pat.ethnicity = Ethnicity.find(params[:ethnicity])
   
    if pat.history_taken
      if params[:patient][:smoking] == 'Current'
        pat.prev_smoking = true
        pat.curr_smoking = true
      elsif params[:patient][:smoking] == 'Previous'
        pat.prev_smoking = true
        pat.curr_smoking = false
      else
        pat.prev_smoking = false
        pat.curr_smoking = false
      end
      
      if params[:patient][:drug_use] == 'Current'
        pat.prev_drug_use = true
        pat.curr_drug_use = true
      elsif params[:patient][:drug_use] == 'Previous'
        pat.prev_drug_use = true
        pat.curr_drug_use = false
      else
        pat.prev_drug_use = false
        pat.curr_drug_use = false
      end
      
      if params[:patient][:etoh_use] == 'Current'
        pat.prev_etoh_use = true
        pat.curr_etoh_use = true
      elsif params[:patient][:etoh_use] == 'Previous'
        pat.prev_etoh_use = true
        pat.curr_etoh_use = false
      else
        pat.prev_etoh_use = false
        pat.curr_etoh_use = false
      end
      
      pat.childhood_diseases = params[:childhood_disease].delete_if {|k,v| v=='0'}.collect{|a| ChildhoodDisease.find(a[0])}
      pat.immunization_histories = params[:immunization_history].delete_if {|k,v| v=='0'}.collect{|a| ImmunizationHistory.find(a[0])}
      pat.family_histories = params[:family_history].delete_if {|k,v| v=='0'}.collect{|a| FamilyHistory.find(a[0])}
    end

    if pat.save
      flash[:notice] = "#{pat.properLastName} updated."
      Transaction.log_edit_patient(session[:user].id, pat.id)
      redirect_to :controller => :home, :action => :patient_home, :patient_id => pat.id
    else
      flash[:error] = "#{pat.properLastName}could not be updated."
      redirect_to :back
    end
  end
	
	def live_search
      search_text = params[:searchtext].upcase 
      
      if search_text =~ /^#*\d+$/
        if search_text =~ /^#/
          search_text = search_text[1..(search_text.length-1)]
        end
        res = PatientIdentifier.patient_by_number(search_text.to_i)
        @results = []
        unless res == nil
          @results << res
        end
        render(:layout => false) and return
      end
      
      phrases = search_text.split(' ')
      
      phrases = phrases.collect { |a|
        m = a.match(/^[A-Z]+/)
        m ? m[0] : nil
      }.select {|a|
        a&&a.length>0
      }
      
      patients = Patient.find(:all)
      
      res = []
    
      for p in patients do
        matches = phrases.select{|s| p.first_name.upcase.include?(s)||p.last_name.upcase.include?(s)}
        res << {:p => p, :score => matches.length} if matches.length>0
      end
      res = res.sort{|a,b| a[:p].to_label <=> b[:p].to_label}.sort{|a,b| b[:score]<=>a[:score]}
      @results = res.collect{|a| a[:p]}
      render :layout => false 
  end
  
  def set_patient
    redirect_to :controller => 'home', :action => "patient_home", :patient_id => params[:patient_id]
  end
  
  def print_immunization_history
    @patient = Patient.find(params[:id], :include => :immunizations)
    
    respond_to do |format|
      format.html { redirect_to :controller => :home, :action => :patient_home, :patient_id => @patient.id }
      format.pdf { render :layout => false }
    end
  end
  
  def print_tb_test_history
    @patient = Patient.find(params[:id], :include => :tb_tests)
    
    respond_to do |format|
      format.html { redirect_to :controller => :home, :action => :patient_home, :patient_id => @patient.id }
      format.pdf { render :layout => false }
    end
  end
  
#  def bp_visits_for_patient
#    @patient = Patient.find(params[:patient_id])
#    @bp_visits = @patient.visits.select{|a| a.blood_press_sys && a.blood_press_dias}.sort{|a,b| b.visit_date <=> a.visit_date}
#  end
end

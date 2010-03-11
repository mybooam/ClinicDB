class PrescriptionController < ApplicationController
	active_scaffold :prescription do |config|
		config.columns =[:given_date, :patient, :drug, :orders, :notes, :signed]
		config.columns[:patient].form_ui = :select
		config.columns[:drug].form_ui = :select
	end

  def add_for_patient
    test = Prescription.new(params[:prescription])
    test.given_date = Date.today()
    
    if test.save
      flash[:notice] = "Prescription added."
      Transaction.log_edit_patient(session[:user].id, test.patient_id)
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
    else
      flash[:error] = "Prescription could not be added.  Make sure that a signature is included."
      redirect_to :back
    end
  end
  
  def set_drug
    if params[:drug_id]
      redirect_to :action => 'new_for_patient', :drug_id => params[:drug_id], :patient_id => params[:patient_id]
    else
      redirect_to :controller => 'drug', :action => 'new_drug', :drug_name => params[:drug_name], :patient_id => params[:patient_id]
    end
  end
  
  def for_patient
    @patient = Patient.find(params[:patient_id])
    @dates = @patient.dates.sort.reverse.select{|a| @patient.prescriptions_for_date(a).length > 0}
    
    @scrips = {}
    for date in @dates
      @scrips[date.to_s] = @patient.prescriptions_for_date(date)
    end
  end
end

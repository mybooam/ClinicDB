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
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
    else
      flash[:error] = "Prescription could not be added."
      redirect_to :action => 'new_for_patient', :drug_id => params[:prescription][:drug_id], :patient_id => params[:prescription][:patient_id]
    end
  end
  
  def set_drug
    if params[:drug_id]
      redirect_to :action => 'new_for_patient', :drug_id => params[:drug_id], :patient_id => params[:patient_id]
    else
      redirect_to :controller => 'drug', :action => 'new_drug', :drug_name => params[:drug_name], :patient_id => params[:patient_id]
    end
  end
end

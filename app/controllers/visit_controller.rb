class VisitController < ApplicationController
	active_scaffold :visit do |config|
		config.label = "Visit"
		config.columns = [:session, :patient, :blood_press_sys, :blood_press_dias, :pulse, :temperature, :weight, :cheif_complaint, :referrals, :users]
		config.list.columns = [:session, :patient, :cheif_complaint]
		
    config.columns[:patient].form_ui = :select
		config.columns[:session].form_ui = :select
		config.columns[:users].form_ui = :select
	end
	
	def add_for_patient
    visit = Visit.new(params[:visit])
    visit.visit_date = Date.today()
    visit.save
    
    redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
  end
end

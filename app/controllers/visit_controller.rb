class VisitController < ApplicationController
	active_scaffold :visit do |config|
		config.label = "Visit"
		config.columns = [:visit_date, :patient, :blood_press_sys, :blood_press_dias, :pulse, :temperature, :weight, :chief_complaint, :referrals, :users]
		config.list.columns = [:visit_date, :patient, :chief_complaint]
		
    config.columns[:patient].form_ui = :select
		config.columns[:users].form_ui = :select
	end
	
	def add_for_patient
    visit = Visit.new(params[:visit])
    visit.visit_date = Date.today()
    if(visit.temperature < 50)
      visit.temperature = visit.temperature * 1.8 + 32
    end
    visit.users = [User.find(params[:user][:users_id])]
    visit.save
    
    redirect_to :controller => 'home', :action => 'patient_home', :patient_id => params[:visit][:patient_id]
  end
end

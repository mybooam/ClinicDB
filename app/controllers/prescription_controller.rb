class PrescriptionController < ApplicationController
	active_scaffold :prescription do |config|
		config.columns =[:given_date, :patient, :drug, :quantity, :units, :orders, :notes, :signed]
		config.columns[:patient].form_ui = :select
		config.columns[:drug].form_ui = :select
	end

    def add_for_patient
      test = Prescription.new(params[:prescription])
      test.given_date = Date.today()
      test.save

      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
    end
end

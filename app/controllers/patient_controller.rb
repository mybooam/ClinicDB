class PatientController < ApplicationController
	active_scaffold :patient do |config|
		config.columns = [:first_name, :last_name, :dob, :sex, :ethnicity, :curr_smoking, :prev_smoking, :smoking_py, :curr_etoh_use, :prev_etoh_use, :etoh_notes, :curr_drug_use, :prev_drug_use, :drug_notes, :adult_illness, :surgeries, :allergies, :immunization_histories, :childhood_diseases, :family_histories]
		
		config.list.columns.exclude :curr_smoking, :prev_smoking, :smoking_py, :curr_etoh_use, :prev_etoh_use, :etoh_notes, :curr_drug_use, :prev_drug_use, :drug_notes, :adult_illness, :surgeries, :allergies, :immunization_histories, :childhood_diseases, :family_histories
		
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
end

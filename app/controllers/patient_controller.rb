class PatientController < ApplicationController
	active_scaffold :patient do |config|
		config.columns = [:first_name, :last_name, :dob, :sex, :ethnicity]
		config.create.columns.add_subgroup "Smoking" do |group|
			group.add(:curr_smoking, :prev_smoking, :smoking_py)
		end
		config.create.columns.add_subgroup "Alcohol" do |group|
			group.add(:curr_etoh_use, :prev_etoh_use, :etoh_notes)
		end
		config.create.columns.add_subgroup "Drugs" do |group|
			group.add(:curr_drug_use, :prev_drug_use, :drug_notes)
		end
		
		config.columns[:ethnicity].form_ui = :select
		config.columns[:curr_smoking].form_ui = :checkbox
		config.columns[:prev_smoking].form_ui = :checkbox
		config.columns[:curr_etoh_use].form_ui = :checkbox
		config.columns[:prev_etoh_use].form_ui = :checkbox
		config.columns[:curr_drug_use].form_ui = :checkbox
		config.columns[:prev_drug_use].form_ui = :checkbox
	end
end

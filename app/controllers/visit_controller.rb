class VisitController < ApplicationController
	active_scaffold :visit do |config|
		config.label = "Visit"
		config.columns = [:patient, :blood_press_sys, :blood_press_dias, :pulse, :temperature, :weight, :cheif_complaint, :referrals, :prescription_entries]
		config.columns[:patient].form_ui = :select
		config.columns[:session].form_ui = :select
	end
end

class PrescriptionController < ApplicationController
	active_scaffold :prescription do |config|
		config.columns =[:given_date, :patient, :drug, :quantity, :units, :orders, :signed]
		config.columns[:patient].form_ui = :select
		config.columns[:drug].form_ui = :select
	end
end

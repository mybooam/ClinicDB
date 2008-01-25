class ImmunizationController < ApplicationController
	active_scaffold :immunization do |config|
		config.columns = [:immunization_drug, :lot_number, :expiration_date, :notes, :visit]
		config.update.columns.exclude :visit
		config.create.columns.exclude :visit
	end
end

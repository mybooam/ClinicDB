class ImmunizationDrugController < ApplicationController
	active_scaffold :immunization_drug do |config|
		config.columns = [:name]
	end
end

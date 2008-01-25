class ImmunizationController < ApplicationController
	active_scaffold :immunization do |config|
		config.label = "Immunization Choices"
		config.columns = [:name]
	end
end

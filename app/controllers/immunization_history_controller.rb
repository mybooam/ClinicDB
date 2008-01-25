class ImmunizationHistoryController < ApplicationController
	active_scaffold :immunization_history do |config|
		config.label = "Immunization History Choices"
		config.columns = [:name]
	end
end

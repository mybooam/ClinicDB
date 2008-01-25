class ChildhoodDiseaseController < ApplicationController
	active_scaffold :childhood_disease do |config|
		config.label = "Childhood Disease Choices"
		config.columns = [:name]
	end
end

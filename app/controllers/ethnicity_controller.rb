class EthnicityController < ApplicationController
	active_scaffold :ethnicity do |config|
		config.label = "Ethnicity Choices"
		config.columns = [:name]
	end
end

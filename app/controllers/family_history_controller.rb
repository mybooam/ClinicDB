class FamilyHistoryController < ApplicationController
	active_scaffold :family_history do |config|
		config.label = "Family History Choices"
		config.columns = [:name]
	end
end

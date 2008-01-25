class PrescriptionController < ApplicationController
	active_scaffold :prescription do |config|
		config.columns =[:drug, :quantity, :orders]
	end
end

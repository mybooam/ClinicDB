class DrugController < ApplicationController
	active_scaffold :drug do |config|
		config.columns = [:name, :units, :prescriptions]
	end
end

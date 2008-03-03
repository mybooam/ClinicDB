class DrugController < ApplicationController
	active_scaffold :drug do |config|
		config.columns = [:name, :units]
	end
end

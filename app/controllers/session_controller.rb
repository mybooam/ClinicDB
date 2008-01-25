class SessionController < ApplicationController
	active_scaffold :session do |config|
		config.label = "Session"
		config.columns = [:session_date, :attending, :visits]
		config.columns[:attending].form_ui = :select
		config.create.columns.exclude :visits
		config.update.columns.exclude :visits
	end
end

class SessionController < ApplicationController
	active_scaffold :session do |config|
		config.label = "Session"
		config.columns = [:session_date, :attending]
		config.columns[:attending].form_ui = :select
	end
end

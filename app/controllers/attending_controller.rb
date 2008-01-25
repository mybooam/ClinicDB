class AttendingController < ApplicationController
	active_scaffold :attending do |config|
      config.label = "Attending Physicians"
      config.columns = [:first_name, :last_name, :email, :sessions]
	  config.create.columns.exclude :sessions
	  config.update.columns.exclude :sessions
      list.sorting = [{:last_name => 'ASC'}, {:first_name => 'ASC'}, {:email => 'ASC'}]
      columns[:last_name].label = "Last Name"
      columns[:first_name].label = "First Name"
    end
end

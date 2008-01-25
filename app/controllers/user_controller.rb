class UserController < ApplicationController
	active_scaffold :user do |config|
      config.label = "Users"
      config.columns = [:first_name, :last_name, :email, :visits]
	  config.update.columns.exclude :visits
	  config.create.columns.exclude :visits
      list.sorting = [{:last_name => 'ASC'}, {:first_name => 'ASC'}, {:email => 'ASC'}]
      columns[:last_name].label = "Last Name"
      columns[:first_name].label = "First Name"
    end
end

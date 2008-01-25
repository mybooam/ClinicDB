class TbTestController < ApplicationController
	active_scaffold :tb_test do |config|
		config.label = "TB Tests"
		config.columns = [:patient, :givenby_user_id, :given_arm, :lot_number, :expiration_date, :readby_user_id, :result, :notes]
		config.columns[:patient].form_ui = :select
	end
end

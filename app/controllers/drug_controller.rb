class DrugController < ApplicationController
	active_scaffold :drug do |config|
		config.columns = [:name]
	end
	
	def test_new_drug
	  s = params[:drug][:name]
    flash[:notice] = Drug.from_user_string(s)
	  
	  redirect_to :action => 'test_drug'
  end
end

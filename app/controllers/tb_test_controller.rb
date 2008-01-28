class TbTestController < ApplicationController
	active_scaffold :tb_test do |config|
		config.label = "TB Tests"
		config.columns = [:patient, :given_date, :givenby_user_id, :given_arm, :lot_number, :expiration_date, :readby_user_id, :read_date, :result, :notes]
		config.columns[:patient].form_ui = :select
	end
	
	def no_show
    @item = TbTest.find(params[:id])
    @item.result="No-Show"
    @item.read_date = Date.today
    if @item.save
      flash[:notice] = "TB Test result saved"
    else
      flash[:error] = "Error applying TB Test result"
    end
	  redirect_to :controller => 'home'
  end
  
  def read
    @item = TbTest.find(params[:id])
  end
  
  def set_result
    @item = TbTest.find(params[:tb_test][:id])
    @item.result=params[:tb_test][:result]
    @item.notes=params[:tb_test][:notes]
    @item.read_date = Date.today
    if @item.save
      flash[:notice] = "TB Test result saved"
    else
      flash[:error] = "Error applying TB Test result"
    end
    redirect_to :controller => 'home'
  end
  
  def add_for_patient
    test = TbTest.new(params[:tb_test])
    test.given_date = Date.today()
    test.save
    
    redirect_to :controller => 'home', :action => 'patient_visit', :patient_id => test.patient_id
  end
end

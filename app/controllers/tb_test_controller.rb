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
    @item = TbTest.find(params[:id])
    @item.result=params[:result]
    @item.notes=params[:notes]
    @item.read_date = Date.today
    if @item.save
      flash[:notice] = "TB Test result saved"
    else
      flash[:error] = "Error applying TB Test result"
    end
    redirect_to :controller => 'home'
  end
end

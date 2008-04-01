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
    @item.readby_user = User.find(params[:tb_test][:readby_user_id])
    if @item.save
      flash[:notice] = "TB Test result saved"
      redirect_to :controller => 'home'
    else
      flash[:error] = "Error applying TB Test result"
      redirect_to :back
    end
  end
  
  def add_for_patient
    test = TbTest.new(params[:tb_test])
    test.given_date = Date.today()
    expdate = params[:other][:expiration_date]
    nums = (expdate.count(',')>0) ? expdate.split(',') : expdate.split('/')
    
    if nums.size==3
      month = nums[0].to_i
      day = nums[1].to_i
      year = nums[2].to_i
    elsif nums.size==2
      month = nums[0].to_i
      day = 1
      year = nums[1].to_i
    end
    
    year = year<100 ? year + 2000 : year

#    print "\n\n#{nums.size} - #{nums.join(" ")} - #{month}/#{day}/#{year}\n\n"
    
    test.expiration_date = Date.civil(year, month, day)
     
    if test.expiration_date - 28 < Date.today()
      flash[:warning] = "PPD batch expires on " + expdate
    end
    
    if test.save
      flash[:notice] = "TB Test saved"
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
    else
      flash[:error] = "Error saving TB Test."
      redirect_to :back
    end
  end
end

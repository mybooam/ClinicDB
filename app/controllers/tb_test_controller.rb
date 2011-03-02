class TbTestController < ApplicationController
	def no_show
    @item = TbTest.find(params[:id])
    @item.result="No-Show"
    @item.read_date = Date.today
    if @item.save
      flash[:notice] = "TB Test result saved"
      Transaction.log_edit_patient(session[:user].id, @item.patient_id)
    else
      flash[:error] = "Error applying TB Test result"
    end
	  redirect_to :controller => 'home'
  end
  
  def read
    @item = TbTest.find(params[:id])
    if @item.overdue?
      flash[:warning] = "This test if overdue.  Please only read if it was read during the correct period."
    end
  end
  
  def set_result
    @item = TbTest.find(params[:tb_test][:id])
    @item.result=params[:tb_test][:result]
    @item.notes=params[:tb_test][:notes]
    @item.read_date = Date.today
    
    if params[:readby_user_id] == ""
      flash[:notice] = "Read by user must be selected."
      redirect_to :back
      return
    end
    
    @item.readby_user = User.find(params[:readby_user_id])
    if @item.save
      flash[:notice] = "TB Test result saved"
      Transaction.log_edit_patient(session[:user].id, @item.patient_id)
      redirect_to :controller => 'home'
    else
      flash[:error] = "Error applying TB Test result"
      redirect_to :back
    end
  end
  
  def add_for_patient
    test = TbTest.new(params[:tb_test])
    test.givenby_user = User.find(params[:givenby_user_id])
    test.given_date = Date.today()
    expdate = params[:other][:expiration_date]
    nums = (expdate.count('-')>0) ? expdate.split('-') : expdate.split('/')
    
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
      Transaction.log_edit_patient(session[:user].id, test.patient_id)
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => test.patient_id
    else
      flash[:error] = "Error saving TB Test."
      redirect_to :back
    end
  end
  
  def for_patient
    @patient = Patient.find(params[:patient_id])
    @dates = @patient.dates.sort.reverse.select{|a| @patient.tb_tests_for_date(a).length > 0}
    
    @tb_tests = {}
    for date in @dates
      @tb_tests[date.to_s] = @patient.tb_tests_for_date(date)
    end
  end
end

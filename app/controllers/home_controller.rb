require 'lib/security_helpers'

class HomeController < ApplicationController
  
  def index
    @tb_tests_open = TbTest.find(:all, :include => [:patient]).select { |a| a.open? }
  end
  
  def patient_home
    begin
      @patient = Patient.find(params['patient_id'], :include=> [:visits, :tb_tests, :immunizations, :prescriptions] )
    rescue
      flash[:error] = "Patient does not exist.  Please contact an administrator if you receivee this message in error"
      redirect_to :controller => :home, :action => :index and return
    end
    
    Transaction.log_view_patient(session[:user].id, @patient.id)
    
    @cards = {}
    @dates = @patient.dates.sort.reverse
    
    for date in @dates
      @cards[date.to_s] = @patient.visits_for_date(date).collect{|a| 
          {:type => 'visit', :partial_name => 'visit/card', :locals => {:visit => a}}} +
        @patient.prescriptions_for_date(date).collect{|a| 
          {:type => 'prescription', :partial_name => 'prescription/card', :locals => {:scrip => a}}} +
        @patient.tb_tests_for_date(date).collect{|a| 
          {:type => 'tb_test', :partial_name => 'tb_test/card', :locals => {:tb_test => a}}} +
        @patient.immunizations_for_date(date).collect{|a| 
          {:type => 'immunization', :partial_name => 'immunization/card', :locals => {:immu => a}}
      }
    end
    
    @latest_visit = @patient.visits.empty? ? nil : @patient.visits.max{ |a,b| a.visit_date <=> b.visit_date}
  end
  
  def list_patients
    @patients = Patient.find(:all).sort{|a,b| a.to_label.downcase <=> b.to_label.downcase }
  end

  def turn_on_admin
    if session[:user] == nil || !session[:user].can_be_admin
      flash[:error] = "Must be logged in to admin user to activate Admin Mode."
      redirect_to :back and return
    end
    
    render 'request_on_admin' and return if !params[:admin] || !params[:admin][:pass]
    
    unless hash_password(params[:admin][:pass]) == Setting.get("admin_password")
      flash[:error] = "Incorrect password."
      redirect_to :back and return
    end
    
    session[:admin_mode] = true
    flash[:warning] = "Administration mode activated.  Proceed with caution."
    redirect_to :action => :index
  end

  def turn_off_admin
    session[:admin_mode] = false
    flash[:notice] = "Logged out of Administration mode."
    redirect_to :back
  end
  
  def update_admin_password
    if hash_password(params[:admin][:old_pass]) != Setting.get("admin_password")
      flash[:error] = "Old admin password is incorrect."
      redirect_to :back
    else  
      unless pass1 =~ /^\w{8,16}$/
        flash[:error] = "Password must be between 8 and 16 alpha-numeric characters"
        redirect_to :back and return
      end
      
      new_pass_hash = hash_password(params[:admin][:new_pass_1])
      
      if(new_pass_hash!=hash_password(params[:admin][:new_pass_2]))
        flash[:error] = "New passwords do not match."
        redirect_to :back
      else   
        Setting.set("admin_password", new_pass_hash)
        flash[:notice] = "Admin password has been changed."
        redirect_to :action => :index
      end
    end
  end
end
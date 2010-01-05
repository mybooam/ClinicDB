require 'lib/security_helpers'

class HomeController < ApplicationController
  def index
    @all_tb_tests = TbTest.find(:all)
    @tb_tests_open = TbTest.find(:all).select { |a| a.open }
  end
  
  def patient_home
    @patient = Patient.find(params['patient_id'], :include=> [:visits, :tb_tests, :immunizations, :prescriptions] )
    
    @cards = {}
    @dates = []
    
    for visit in @patient.visits
      if @cards[visit.visit_date.to_s] == nil
        @cards[visit.visit_date.to_s] = []
        @dates << visit.visit_date
      end
      @cards[visit.visit_date.to_s] << {:type => 'visit', :partial_name => 'visit/card', :locals => {:visit => visit}}
    end
    
    for scrip in @patient.prescriptions
      if @cards[scrip.given_date.to_s] == nil
        @cards[scrip.given_date.to_s] = []
        @dates << scrip.given_date
      end
      @cards[scrip.given_date.to_s] << {:type => 'prescription', :partial_name => 'prescription/card', :locals => {:scrip => scrip}}
    end
    
    for tb_test in @patient.tb_tests
      if @cards[tb_test.given_date.to_s] == nil
        @cards[tb_test.given_date.to_s] = []
        @dates << tb_test.given_date
      end
      @cards[tb_test.given_date.to_s] << {:type => 'tb_test', :partial_name => 'tb_test/card', :locals => {:tb_test => tb_test}}
    end
    
    for immunization in @patient.immunizations
      if @cards[immunization.given_date.to_s] == nil
        @cards[immunization.given_date.to_s] = []
        @dates << immunization.given_date
      end
      @cards[immunization.given_date.to_s] << {:type => 'immunization', :partial_name => 'immunization/card', :locals => {:immu => immunization}}
    end
    
    @dates = @dates.uniq.sort{|a, b| b <=> a}
  end
  
  def list_patients
    @patients = Patient.find(:all).sort{|a,b| a.to_label.downcase <=> b.to_label.downcase }
  end

  def turn_on_admin
    pass_hash = hash_password(params[:admin][:pass])
    unless pass_hash == Setting.get("admin_password")
      flash[:error] = "Incorrect password."
      redirect_to :back
      return
    end
    
    cookies[:admin_mode] = { :value => "true", :expires => 1.hour.from_now }
    flash[:warning] = "Administration mode activated.  Proceed with caution."
    redirect_to :action => :index
  end

  def turn_off_admin
    cookies[:admin_mode] = { :value => "false", :expires => 1.hour.from_now }
    flash[:notice] = "Logged out of Administration mode."
    redirect_to :back
  end
  
  def update_admin_password
    puts params[:admin][:old_pass]
    old_pass_hash = hash_password(params[:admin][:old_pass])
    if old_pass_hash != Setting.get("admin_password")
      flash[:error] = "Old admin password is incorrect."
      redirect_to :back
    else  
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
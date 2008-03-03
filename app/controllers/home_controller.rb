class HomeController < ApplicationController
  def index
    @all_tb_tests = TbTest.find(:all)
    @tb_tests_open = TbTest.find(:all).select { |item| 
      item.open
    }
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
    
    @dates = @dates.uniq.sort
  end
  
  def add_patient
    pat = Patient.new(params[:patient])
    pat.dob = Date.parse(params[:patient][:dob], true)
    if pat.dob>Date.today()
      pat.dob = Date.civil(pat.dob.year-100, pat.dob.mon, pat.dob.mday)
    end
    pat.ethnicity = Ethnicity.find(:all, :conditions=>"name LIKE '#{params[:ethnicity][:ethnicity]}'")[0]
    pat.childhood_diseases = params[:childhood_disease].delete_if {|k,v| v=='0'}.collect{|a| ChildhoodDisease.find(a[0])}
    pat.immunization_histories = params[:immunization_history].delete_if {|k,v| v=='0'}.collect{|a| ImmunizationHistory.find(a[0])}
    pat.family_histories = params[:family_history].delete_if {|k,v| v=='0'}.collect{|a| FamilyHistory.find(a[0])}
    pat.save
    
    redirect_to :action => :patient_home, :patient_id => pat.id
  end
  
  def list_patients
    @patients = Patient.find(:all).sort{|a,b| a.to_label.downcase <=> b.to_label.downcase }
  end
end
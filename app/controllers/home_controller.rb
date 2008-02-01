class HomeController < ApplicationController
  def index
    @all_tb_tests = TbTest.find(:all)
    @tb_tests_open = TbTest.find(:all).select { |item| 
      (item.result == nil || item.result == "") && item.given_date + 2 <= Date.today
    }
  end
  
  def patient_home
    @patient = Patient.find(params['patient_id'], :include=> [:visits, :tb_tests, :immunizations, :prescriptions] )
    
    @todays_visits = @patient.visits.select{|a| a.visit_date == Date.today()}
    @todays_tb_tests = @patient.tb_tests.select{|a| a.given_date == Date.today() || a.read_date == Date.today()}
    @todays_prescriptions = @patient.prescriptions.select{|a| a.given_date == Date.today()}
    @todays_immunizations = @patient.immunizations.select{|a| a.given_date == Date.today()}
    
    @other_visits = @patient.visits.delete_if{|a| @todays_visits.include?(a)}.sort{|a,b| b.visit_date <=> a.visit_date }
    @other_tb_tests = @patient.tb_tests.delete_if{|a| @todays_tb_tests.include?(a) }.sort{|a,b| b.given_date <=> a.given_date }
    @other_prescriptions = @patient.prescriptions.delete_if{|a| @todays_prescrioptions.include?(a) }.sort{|a,b| b.given_date <=> a.given_date }
    @other_immunizations = @patient.immunizations.delete_if{|a| @todays_immunizations.include?(a) }.sort{|a,b| b.given_date <=> a.given_date }
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
end
class HomeController < ApplicationController
  def index
    @all_tb_tests = TbTest.find(:all)
    @tb_tests_open = TbTest.find(:all).select { |item| 
      (item.result == nil || item.result == "") && item.given_date + 2 <= Date.today
    }
  end
  
  def patient_visit
    @patient = Patient.find(params['patient_id'])
  end
  
  def add_patient
    pat = Patient.new(params[:patient])
    pat.dob = Date.parse(params[:patient][:dob], true)
    pat.ethnicity = Ethnicity.find(:all, :conditions=>"name LIKE '#{params[:ethnicity][:ethnicity]}'")[0]
    pat.childhood_diseases = params[:childhood_disease].delete_if {|k,v| v=='0'}.collect{|a| ChildhoodDisease.find(a[0])}
    pat.immunization_histories = params[:immunization_history].delete_if {|k,v| v=='0'}.collect{|a| ImmunizationHistory.find(a[0])}
    pat.family_histories = params[:family_history].delete_if {|k,v| v=='0'}.collect{|a| FamilyHistory.find(a[0])}
    pat.save
    
    redirect_to :action => :patient_visit, :patient_id => pat.id
  end
end
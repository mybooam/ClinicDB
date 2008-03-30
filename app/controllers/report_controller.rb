class ReportController < ApplicationController
  def patients_by_session
    @dates = []
    @sessions = {}
    @patients = {}
    
    visits = Visit.find(:all, :include=> [:patient])
    prescriptions = Prescription.find(:all, :include=> [:patient])
    tb_tests = TbTest.find(:all, :include=> [:patient])
    immunizations = Immunization.find(:all, :include=> [:patient])
    
    for visit in visits
      if @patients[visit.visit_date.to_s] == nil
        @patients[visit.visit_date.to_s] = []
        @dates << visit.visit_date
      end
      @patients[visit.visit_date.to_s] << visit.patient
      @patients[visit.visit_date.to_s].uniq!
    end
    
    for scrip in prescriptions
      if @patients[scrip.given_date.to_s] == nil
        @patients[scrip.given_date.to_s] = []
        @dates << scrip.given_date
      end
      @patients[scrip.given_date.to_s] << scrip.patient
      @patients[scrip.given_date.to_s].uniq!
    end
    
    for tb_test in tb_tests
      if @patients[tb_test.given_date.to_s] == nil
        @patients[tb_test.given_date.to_s] = []
        @dates << tb_test.given_date
      end
      @patients[tb_test.given_date.to_s] << tb_test.patient
      @patients[tb_test.given_date.to_s].uniq!
    end
    
    for immunization in immunizations
      if @patients[immunization.given_date.to_s] == nil
        @patients[immunization.given_date.to_s] = []
        @dates << immunization.given_date
      end
      @patients[immunization.given_date.to_s] << immunization.patient
      @patients[immunization.given_date.to_s].uniq!
    end
    all_sessions = Session.find(:all, :include => [:attending])
    @dates = @dates.uniq.sort{|a, b| b <=> a}
    for date in @dates
      session = all_sessions.find{|a| a.session_date == date}
      if session
        @sessions[date.to_s] = session
      end
      @patients[date.to_s].sort! {|a,b| a.to_label.downcase <=> b.to_label.downcase }
    end
  end
end
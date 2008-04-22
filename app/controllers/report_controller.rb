class ReportController < ApplicationController
  def index
    @stats = []
    
    patients = Patient.find(:all, :include => [:tb_tests, :visits])
    patients_with_hx = patients.select{|a| a.history_taken}
    
    ptstats = []
    ptstats << {:name => "Total Patients", :value => patients.size }
    ptstats << {:name => "Patients with histories", :value => patients_with_hx.size}
    ptstats << {:name => "Patients with history percentage", :value => "%.0f%%" % (100*patients_with_hx.size/patients.size)}
    pts_with_visits = patients.select{|a| !a.visits.empty? }.size
    ptstats << {:name => "Patients with visits", :value => pts_with_visits}
    pts_with_tb_tests = patients.select{|a| !a.tb_tests.empty? }.size
    ptstats << {:name => "Patients with visits", :value => pts_with_tb_tests}
    
    @stats << {:name=>"Patients", :stats => ptstats}
    
    visits = Visit.find(:all)
    visitstats = []
    visitstats << {:name => "Total Visits", :value => visits.size }
    visitstats << {:name => "Visits per patients", :value => "%.2f" % (visits.size.to_f/pts_with_visits.to_f)}
    
    @stats << {:name=>"Visits", :stats => visitstats}
    
    tb_tests = TbTest.find(:all)
    tbstats = []
    tbstats << {:name => "Total TB Tests", :value => tb_tests.size }
    tbstats << {:name => "TB Tests per patients", :value => "%.2f" % (tb_tests.size.to_f/pts_with_tb_tests.to_f)}
    tbstats << {:name => "Positive results", :value => tb_tests.select{|a| a.positive?}.size}
    tbstats << {:name => "No-Show percentage", :value => "%.0f%%" % (100*tb_tests.select{|a| a.noshow?}.size.to_f/tb_tests.size.to_f)}
    
    @stats << {:name=>"TB Tests", :stats => tbstats}
    
    users = User.find(:all, :include => [:visits, :tb_tests_given, :tb_tests_read])
    
    userstats = []
    userstats << {:name => "Total users", :value => users.size}
    userstats << {:name => "Active users", :value => users.select{|a| a.active }.size}
    users_with_visits = users.select{|a| !a.visits.empty? }.size
    users_with_tb_tests = users.select{|a| !a.tb_tests.empty? }.size
    userstats << {:name => "Users that have done Visits", :value => users_with_visits}
    userstats << {:name => "Visits per user", :value => "%.2f" % (visits.size.to_f/users_with_visits.to_f)}
    userstats << {:name => "Users that have done TB Tests", :value => users_with_tb_tests}
    userstats << {:name => "TB Tests per user", :value => "%.2f" % (tb_tests.size.to_f/users_with_tb_tests.to_f)}
    
    @stats << {:name=>"Users", :stats => userstats}
  end
      
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
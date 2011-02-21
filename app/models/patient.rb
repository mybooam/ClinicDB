require 'lib/string_helpers'

class Patient < ActiveRecord::Base
	has_many :visits
	has_many :tb_tests
	belongs_to :ethnicity
	
	has_and_belongs_to_many :childhood_diseases
	has_and_belongs_to_many :family_histories
	has_and_belongs_to_many :immunization_histories
	
	has_many :prescriptions
	has_many :immunizations
	
	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_presence_of :dob
  validates_presence_of :sex
  validates_presence_of :ethnicity_id
  
  encrypted_field = %w(adult_illness surgeries allergies drug_notes etoh_notes)
  
  before_save      EncryptionWrapper.new(encrypted_field, "Patient")
  after_save       EncryptionWrapper.new(encrypted_field, "Patient")
  after_find       EncryptionWrapper.new(encrypted_field, "Patient")
  after_initialize EncryptionWrapper.new(encrypted_field, "Patient")
  
  def after_find
  end
	
  def patient_number
    PatientIdentifier.get_or_create_for_patient(self).identifier
  end
  
	def to_label
	  "#{last_name}, #{first_name} (#{dob_str})"
	end
	
	def dob_str
	  '%d/%d/%02d' % [dob.mon, dob.mday, dob.year]
  end
  
  def age
    Date.today().year - dob.year - ((dob.mon*100+dob.mday >  Date.today().mon*100+Date.today().mday) ? 1 : 0)
  end
  
  def name
	  "#{last_name}, #{first_name}"
  end
  
  def properLastName
    "#{isMale? ? 'Mr.' : 'Ms.'} #{last_name}"
  end
  
  def isMale?
    sex=='Male'
  end
  
  def dates
    (visits.collect{|a| a.visit_date} + 
      prescriptions.collect{|a| a.given_date} +
      tb_tests.collect{|a| a.given_date} +
      immunizations.collect{|a| a.given_date}).uniq
  end
  
  def visit_for_date(date)
    on = visits_for_date date
    on.length > 0 ? on[0] : nil
  end
  
  def visits_for_date(date)
    visits.select {|a| a.visit_date == date}
  end
  
  def prescriptions_for_date(date)
    prescriptions.select {|a| a.given_date == date}
  end
  
  def tb_tests_for_date(date)
    tb_tests.select {|a| a.given_date == date}
  end
  
  def immunizations_for_date(date)
    immunizations.select {|a| a.given_date == date}
  end
  
  def self.search_by_string(search_text) 
    search_text.upcase!
    
    if search_text =~ /^#*\d+$/
      if search_text =~ /^#/
        search_text = search_text[1..(search_text.length-1)]
      end
      res = PatientIdentifier.patient_by_number(search_text.to_i)
      return res == nil ? [] : [res]
    end
    
    phrases = search_text.split(' ')
    
    phrases = phrases.collect { |a|
      m = a.match(/^[A-Z]+/)
      m ? m[0] : nil
    }.select {|a|
      a&&a.length>0
    }
    
    rows_from_sql = Patient.connection.execute "SELECT first_name, last_name, id FROM patients"
    rows_from_sql.each{ |p| puts p}
    
    res = []
    do_fuzzy_patient_search = Setting.get_b("fuzzy_patient_search", false)
    
    rows_from_sql.each do |p|
      matches = phrases.select{|s| p['first_name'].upcase.include?(s)||p['last_name'].upcase.include?(s)}
      if matches.length > 0
        res << {:p => Patient.find(p['id']), :score => matches.length}
      elsif(do_fuzzy_patient_search)
        dist = 0
        at_least_one_acceptable = false
        phrases.each{|s| 
          fn_dist = edit_dist(p['first_name'].upcase, s)
          ln_dist = edit_dist(p['last_name'].upcase, s)
          dist += [fn_dist, ln_dist].min
          if(ln_dist<fn_dist) 
            at_least_one_acceptable = true if ln_dist < p['last_name'].length/4
          else
            at_least_one_acceptable = true if fn_dist < p['first_name'].length/4
          end
        }
        res << {:p => Patient.find(p['id']), :score => -dist} if at_least_one_acceptable
      end
    end
    res = res.sort{|a,b| a[:p].to_label <=> b[:p].to_label}.sort{|a,b| b[:score]<=>a[:score]}
    res.collect{|a| a[:p]} 
  end
end

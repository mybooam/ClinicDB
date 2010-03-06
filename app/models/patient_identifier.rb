class PatientIdentifier < ActiveRecord::Base
  validates_presence_of :identifier
  validates_uniqueness_of :identifier
  
  belongs_to :patient
  
  def self.get_or_create_for_patient(pat)
    ident = find_by_patient_id(pat.id)
    if ident
      return ident
    else
      give_identifier(pat)
    end
    find_by_patient_id(pat.id)
  end
  
  def self.give_identifier(pat)
    success = false
    attempts = 0
    while !success && attempts<10
      success = new(:identifier => get_next_identifier_value, :patient => pat).save
      attempts = attempts+1
    end
    
    attempts = 0
    while !success && attempts<10
      #fall back to some really big random number higher than the last identifier
      success = new(:identifier => (maximum(:identifier) + rand(1000)), :patient => pat)
      attempts = attempts+1
    end
    
    if !success
      new(:identifier => pat.id*100, :patient => pat)
    end
    
    #puts "Given patient identifier #{find_by_patient_id(pat.id).to_label}"
  end
  
  def self.get_next_identifier_value
    if count(:all)==0
      return 14815
    end
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    next_num = maximum(:identifier) + primes[rand(primes.length)]
    (next_num % 100 == 0) ? next_num + 1 : next_num
  end
  
  def self.patient_by_number(ident_num)
    ident = find_by_identifier(ident_num)
    if ident
      ident.patient
    else
      nil
    end
  end
  
  def to_label
    "#{identifier} - #{patient_id ? patient.to_label : '<NULL>'}"  
  end
end

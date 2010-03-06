class VisitIdentifier < ActiveRecord::Base
  validates_presence_of :identifier
  validates_uniqueness_of :identifier
  
  belongs_to :visit
  
  def self.get_or_create_for_visit(v)
    ident = find_by_visit_id(v.id)
    if ident
      return ident
    else
      give_identifier(v)
      return find_by_visit_id(v.id)
    end
  end
  
  def self.give_identifier(v)
    success = false
    attempts = 0
    while !success && attempts<10
      success = new(:identifier => get_next_identifier_value, :visit => v).save
      attempts = attempts+1
    end
    
    attempts = 0
    while !success && attempts<10
      #fall back to some really big random number higher than the last identifier
      success = new(:identifier => (maximum(:identifier) + rand(1000)), :visit => v)
      attempts = attempts+1
    end
    
    if !success
      new(:identifier => v.id*100, :visit => v)
    end
    
    puts "Given visit identifier #{find_by_visit_id(v.id).to_label}"
  end
  
  def self.get_next_identifier_value
    if count(:all)==0
      return 81516
    end
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    next_num = maximum(:identifier) + primes[rand(primes.length)]
    (next_num % 100 == 0) ? next_num + 1 : next_num
  end
  
  def self.visit_by_number(ident_num)
    ident = find_by_identifier(ident_num)
    if ident
      ident.visit
    else
      nil
    end
  end
  
  def to_label
    "#{identifier} - #{visit_id ? visit.to_label : '<NULL>'}"  
  end
end

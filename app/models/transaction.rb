class Transaction < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :transaction_type
  validates_presence_of :patient_id
  
  validates_inclusion_of :transaction_type, :in => %w( create edit view )

  def self.for_user(u_id)
    Transaction.find(:all, :conditions => "user_id = #{u_id}")
  end

  def self.for_patient(pat_id)
    Transaction.find(:all, :conditions => "patient_id = #{pat_id}")
  end
  
  def self.log_create_patient(u_id, pat_id)
    log(u_id, pat_id, "create")
  end
  
  def self.log_edit_patient(u_id, pat_id)
    log(u_id, pat_id, "edit")
  end
  
  def self.log_view_patient(u_id, pat_id)
    log(u_id, pat_id, "view")
  end
  
  def self.log(u_id, pat_id, type)
    t = Transaction.new()
    t.user_id = u_id
    t.transaction_type = type
    t.patient_id = pat_id
    t.save
  end
end

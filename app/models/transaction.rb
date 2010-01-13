class Transaction < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :type
  validates_presence_of :record_type
  validates_presence_of :record_id
  
  validates_inclusion_of :type, :in => %w( create edit view )

  def self.for_user(u_id)
    Transaction.find(:all, :conditions => "user_id = #{u_id}")
  end
end

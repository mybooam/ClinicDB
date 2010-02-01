class EducationLevel < ActiveRecord::Base
  has_many :visits
  
  validates_presence_of :name
  validates_uniqueness_of :name
end

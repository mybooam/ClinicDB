class PopulateUsersAndAttendings < ActiveRecord::Migration
  def self.up
	User.create :first_name => "Jay", :last_name => "Liu", :email => "jliu3@lsuhsc.edu"
	User.create :first_name => "Powell", :last_name => "Kinney", :email => "pkinney@lsuhsc.edu"
	User.create :first_name => "Thomas", :last_name => "Cullen", :email => "tculle@lsuhsc.edu"
	
	Attending.create :first_name => "Gred", :last_name => "Fernandez"
  end

  def self.down
  end
end

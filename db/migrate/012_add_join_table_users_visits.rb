class AddJoinTableUsersVisits < ActiveRecord::Migration
  def self.up
    
    create_table :users_visits, :engine => :InnoDB, :primary_key => 'users_visits_index', :id=> false do |t|
      t.column :user_id, :integer
      t.column :visit_id, :integer
    end
	
	add_index :users_visits, [:user_id, :visit_id], :name => 'users_visits_index'
  end

  def self.down
    drop_table :users_visits
  end
end

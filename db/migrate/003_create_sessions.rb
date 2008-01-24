class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions, :engine => :InnoDB do |t|
	    t.column :session_date, :date, :null => false
	    t.column :attending_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sessions
  end
end

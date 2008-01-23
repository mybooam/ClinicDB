class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :engine => :InnoDB do |t|
	  t.column :first_name, :string, :null => false
	  t.column :last_name, :string, :null => false
	  t.column :email, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

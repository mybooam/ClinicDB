class CreateEthnicities < ActiveRecord::Migration
  def self.up
    create_table :ethnicities, :engine => :InnoDB do |t|
	    t.column :name, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ethnicities
  end
end

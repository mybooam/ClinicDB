class CreateImmunizations < ActiveRecord::Migration
  def self.up
    create_table :immunizations, :engine => :InnoDB do |t|
       t.column :name, :string, :null => false
       t.timestamps
    end
	
	create_table :immunizations_patients, :engine => :InnoDB do |t|
		t.column :patient_id, :integer, :null => false
		t.column :immunization_id, :integer, :null => false
	end
  end

  def self.down
    drop_table :immunizations
	drop_table :immunizations_patients
  end

end

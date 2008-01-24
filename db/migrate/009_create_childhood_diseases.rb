class CreateChildhoodDiseases < ActiveRecord::Migration
  def self.up
    create_table :childhood_diseases, :engine => :InnoDB do |t|
       t.column :name, :string, :null => false
       t.timestamps
    end
	
	  create_table :childhood_diseases_patients, :engine => :InnoDB do |t|
  		t.column :patient_id, :integer, :null => false
  		t.column :childhood_disease_id, :integer, :null => false
  	end
  end

  def self.down
    drop_table :childhood_diseases
	  drop_table :childhood_diseases_patients
  end
end

class CreateChildhoodDiseases < ActiveRecord::Migration
  def self.up
    create_table :childhood_diseases, :engine => :InnoDB do |t|
       t.column :name, :string, :null => false
       t.timestamps
    end
	
	  create_table :childhood_diseases_patients, :engine => :InnoDB, :primary_key => 'childhood_diseases_patients_index', :id=> false do |t|
  		t.column :patient_id, :integer, :null => false
  		t.column :childhood_disease_id, :integer, :null => false
  	end
	
	add_index :childhood_diseases_patients, [:patient_id, :childhood_disease_id], :name => 'childhood_diseases_patients_index'
  end

  def self.down
    drop_table :childhood_diseases
	  drop_table :childhood_diseases_patients
  end
end

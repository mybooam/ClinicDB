class CreateImmunizationHistories < ActiveRecord::Migration
  def self.up
		create_table :immunization_histories, :engine => :InnoDB do |t|
			t.column :name, :string, :null => false
			t.timestamps
		end
	
		create_table:immunization_histories_patients, :engine => :InnoDB, :primary_key => 'immunization_histories_patients_index', :id=> false do |t|
			t.column :patient_id, :integer, :null => false
			t.column :immunization_history_id, :integer, :null => false
		end
	
		add_index :immunization_histories_patients, [:patient_id, :immunization_history_id], :name => 'immunization_histories_patients_index'
  end

  def self.down
    drop_table :immunization_histories
	drop_table :immunization_histories_patients
  end
end

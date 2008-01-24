class CreateFamilyHistories < ActiveRecord::Migration
  def self.up
    create_table :family_histories, :engine => :InnoDB do |t|
		t.column :name, :string, :null => false
		t.timestamps
    end
	
	create_table :family_histories_patients, :engine => :InnoDB do |t|
		t.column :patient_id, :integer, :null => false
		t.column :family_history_id, :integer, :null => false
	end
  end

  def self.down
    drop_table :family_histories
	drop_table :family_histories_patients
  end
end

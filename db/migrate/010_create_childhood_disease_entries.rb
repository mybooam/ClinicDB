class CreateChildhoodDiseaseEntries < ActiveRecord::Migration
  def self.up
    create_table :childhood_disease_entries, :engine => :InnoDB do |t|
       t.column :patient_id, :integer, :null => false
       t.column :childhood_disease_choice_id, :integer, :null => false
       t.timestamps
    end
  end

  def self.down
    drop_table :childhood_disease_entries
  end
end

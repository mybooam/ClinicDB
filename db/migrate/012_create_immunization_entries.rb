class CreateImmunizationEntries < ActiveRecord::Migration
  def self.up
    create_table :immunization_entries, :engine => :InnoDB do |t|
       t.column :patient_id, :integer, :null => false
       t.column :immunization_choice_id, :integer, :null => false
       t.timestamps
    end
  end

  def self.down
    drop_table :immunization_entries
  end
end

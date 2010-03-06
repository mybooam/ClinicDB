class CreatePatientIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :patient_identifiers do |t|
      t.integer :identifier
      t.integer :patient_id
    end
  end

  def self.down
    drop_table :patient_identifiers
  end
end

class AddPatientIdToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :patient_id, :integer, :null=>false, :default => -1
    remove_column :transactions, :record_type
    remove_column :transactions, :record_id
  end

  def self.down
    remove_column :transactions, :patient_id
    add_column :transactions, :record_type, :string
    add_column :transactions, :record_id, :integer
  end
end
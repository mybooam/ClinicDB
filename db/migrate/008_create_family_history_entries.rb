class CreateFamilyHistoryEntries < ActiveRecord::Migration
  def self.up
    create_table :family_history_entries, :engine => :InnoDB do |t|
       t.column :patient_id, :integer, :null => false
       t.column :family_history_choice_id, :integer, :null => false
       t.timestamps
    end
  end

  def self.down
    drop_table :family_history_entries
  end
end

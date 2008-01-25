class CreateImmunizationDrugs < ActiveRecord::Migration
  def self.up
    create_table :immunization_drugs do |t|
      t.column :name, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :immunization_drugs
  end
end

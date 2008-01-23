class CreateImmunizationChoices < ActiveRecord::Migration
  def self.up
    create_table :immunization_choices, :engine => :InnoDB do |t|
       t.column :name, :string, :null => false
       t.timestamps
    end
  end

  def self.down
    drop_table :immunization_choices
  end
end

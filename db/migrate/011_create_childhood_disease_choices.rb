class CreateChildhoodDiseaseChoices < ActiveRecord::Migration
  def self.up
    create_table :childhood_disease_choices, :engine => :InnoDB do |t|
       t.column :name, :string, :null => false
       t.timestamps
    end
  end

  def self.down
    drop_table :childhood_disease_choices
  end
end

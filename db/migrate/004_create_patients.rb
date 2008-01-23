class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients, :engine => :InnoDB do |t|
	  t.column :first_name, :string, :null => false
	  t.column :last_name, :string, :null => false
	  t.column :dob, :date, :null => false
	  t.column :sex, :enum, :limit => [:male, :female], :null => false
	  t.column :ethnicity, :integer, :null => false
      t.column :prev_etoh_use, :boolean
	  t.column :curr_etoh_use, :boolean
	  t.column :etoh_notes, :text
	  t.column :prev_drug_use, :boolean
	  t.column :curr_drug_use, :boolean
	  t.column :drug_notes, :text
	  t.column :prev_smoking, :boolean
	  t.column :curr_smoking, :boolean
	  t.column :smoking_py, :integer
	  t.column :adult_illness, :text
	  t.column :surgeries, :text
	  t.column :allergies, :text
	  t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end

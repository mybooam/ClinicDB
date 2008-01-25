class CreateImmunizations < ActiveRecord::Migration
	def self.up
		create_table :immunizations, :engine => :InnoDB do |t|
			t.column :visit_id, :integer, :null => false
			t.column :immunization_drug_id, :integer, :null => false
			t.column :lot_number, :string, :null => false
			t.column :expiration_date, :date, :null => false
			t.column :notes, :text
			t.timestamps
		end
	end

	def self.down
		drop_table :immunizations
	end
end

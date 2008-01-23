class AddedPrescriptionTable < ActiveRecord::Migration
  def self.up
    create_table :prescription_entries, :engine => :InnoDB do |t|
      t.column :visit_id, :integer
      t.column :prescription_id, :integer
      t.column :quantity, :float
      t.column :units, :string
      t.column :orders, :text
      t.timestamps
    end
    
    create_table :prescription_choices, :engine => :InnoDB do |t|
      t.column :name, :string
      t.column :units, :string
      t.timestamps
    end
    
    remove_column :visits, :perscriptions
  end

  def self.down
    drop_table :prescription_entries
    drop_table :prescription_choices
    add_column :visits, :perscriptions, :text
  end
end

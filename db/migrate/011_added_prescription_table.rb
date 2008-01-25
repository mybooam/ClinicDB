class AddedPrescriptionTable < ActiveRecord::Migration
  def self.up
    create_table :prescriptions, :engine => :InnoDB do |t|
      t.column :visit_id, :integer
      t.column :drug_id, :integer
      t.column :quantity, :float
      t.column :units, :string
      t.column :orders, :text
      t.timestamps
    end
    
    create_table :drugs, :engine => :InnoDB do |t|
      t.column :name, :string
      t.column :units, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :prescriptions
    drop_table :drugs
  end
end

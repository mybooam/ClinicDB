class CreatePharmacies < ActiveRecord::Migration
  def self.up
    create_table :pharmacies do |t|
      t.string :name

      t.timestamps
    end
    
    Pharmacy.create(:name => "Unknown")
    Pharmacy.create(:name => "Other")
  end

  def self.down
    drop_table :pharmacies
  end
end

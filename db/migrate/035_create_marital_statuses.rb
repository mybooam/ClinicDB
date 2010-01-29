class CreateMaritalStatuses < ActiveRecord::Migration
  def self.up
    create_table :marital_statuses do |t|
      t.string :name

      t.timestamps
    end
    
    MaritalStatus.create(:name => "Unknown")
    MaritalStatus.create(:name => "Single")
    MaritalStatus.create(:name => "Married")
    MaritalStatus.create(:name => "Divorced")
    MaritalStatus.create(:name => "Widowed")
  end

  def self.down
    drop_table :marital_statuses
  end
end

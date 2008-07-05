class AddHivTestTable < ActiveRecord::Migration
  def self.up
    create_table :hiv_test, :engine => :InnoDB do |t|
      t.column :patient_id, :integer, :null => false
      t.column :given_date, :date, :null => false
      t.column :givenby_user_id, :integer, :null => false
      t.column :lot_number, :string, :null => false
      t.column :expiration_date, :date, :null => false
      t.column :result, :string
      t.column :confirm_test, :string
      t.column :referral, :string
      t.column :notes, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :hiv_test
  end
end

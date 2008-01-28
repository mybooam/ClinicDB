class CreateTbTests < ActiveRecord::Migration
  def self.up
    create_table :tb_tests, :engine => :InnoDB do |t|
      t.column :patient_id, :integer, :null => false
      t.column :given_date, :date, :null => false
      t.column :givenby_user_id, :integer, :null => false
      t.column :given_arm, :string, :null => false
      t.column :lot_number, :string, :null => false
      t.column :expiration_date, :date, :null => false
      t.column :read_date, :date
      t.column :readby_user_id, :integer
      t.column :result, :string
      t.column :notes, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :tb_tests
  end
end

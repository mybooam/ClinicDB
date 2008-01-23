class CreateTbTests < ActiveRecord::Migration
  def self.up
    create_table :tb_tests, :engine => :InnoDB do |t|
      t.column :patient_id, :integer, :null => false
      t.column :givenby_user_id, :integer, :null => false
      t.column :given_arm, :enum, :limit => [:right, :left], :null => false
      t.column :lot_number, :string, :null => false
      t.column :expiration_date, :date, :null => false
      t.column :readby_user_id, :integer
      t.column :result, :enum, :limit => [:positive, :negative, :unknown]
      t.column :notes, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :tb_tests
  end
end

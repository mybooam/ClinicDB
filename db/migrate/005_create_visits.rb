class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits, :engine => :InnoDB do |t|
      t.column :session_id, :integer
      t.column :patient_id, :integer
      t.column :seen_by_user1_id, :integer
      t.column :seen_by_user1_id, :integer
      t.column :blood_press_sys, :float
      t.column :blood_press_dias, :float
      t.column :temperature, :float
      t.column :pulse, :float
      t.column :weight, :float
      t.column :cheif_complaint, :text
      t.column :assessment, :text
      t.column :perscriptions, :text
      t.column :referrals, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :visits
  end
end

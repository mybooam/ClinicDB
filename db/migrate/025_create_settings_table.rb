class CreateSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings, :engine => :InnoDB do |t|
      t.column :key, :text
      t.column :value, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end

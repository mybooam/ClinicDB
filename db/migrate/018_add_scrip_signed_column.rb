class AddScripSignedColumn < ActiveRecord::Migration
  def self.up
    add_column :prescriptions, :signed, :string
  end

  def self.down
    remove_column :prescriptions, :signed
  end
end

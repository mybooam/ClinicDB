class AddVersionToVisit < ActiveRecord::Migration
  def self.up
    add_column :visits, :version, :string, :null => false, :default => "soap"
  end

  def self.down
    remove_column :visits, :version
  end
end
